//
//  DemoViewModel.swift
//  TidepoolOnboardingDemo
//
//  Created by Darin Krauss on 3/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI
import TidepoolOnboardingKitUI

class DemoViewModel: ObservableObject, OnboardingProvider, OnboardingDelegate, CGMManagerCreateDelegate, CGMManagerOnboardDelegate, PumpManagerCreateDelegate, PumpManagerOnboardDelegate, ServiceCreateDelegate, ServiceOnboardDelegate, CompletionDelegate, DeviceOrientationController {
    let onboarding: TidepoolOnboardingUI

    @Published var isComplete: Bool = false

    init() {
        if let onboardingRawState = UserDefaults.standard.onboardingRawState,
           let onboarding = TidepoolOnboardingUI(rawState: onboardingRawState) {
            self.onboarding = onboarding
        } else {
            self.onboarding = TidepoolOnboardingUI()
        }

        // If fully onboarded then reset (to avoid delete/resintall)
        if onboarding.isOnboarded {
            onboarding.reset()
        }

        onboarding.onboardingDelegate = self
    }

    // OnboardingProvider

    var allowSkipOnboarding: Bool = true

    // OnboardingDelegate

    func onboardingDidUpdateState(_ onboarding: OnboardingUI) {
        UserDefaults.standard.onboardingRawState = onboarding.rawState
    }

    func onboarding(_ onboarding: OnboardingUI, hasNewTherapySettings therapySettings: TherapySettings) {}

    // NotificationAuthorizationProvider

    private var notificationAuthorization: NotificationAuthorization = .notDetermined

    func getNotificationAuthorization(_ completion: @escaping (NotificationAuthorization) -> Void) {
        completion(notificationAuthorization)
    }

    func authorizeNotification(_ completion: @escaping (NotificationAuthorization) -> Void) {
        notificationAuthorization = .authorized
        completion(notificationAuthorization)
    }

    // HealthStoreAuthorizationProvider

    private var healthStoreAuthorization: HealthStoreAuthorization = .notDetermined

    func getHealthStoreAuthorization(_ completion: @escaping (HealthStoreAuthorization) -> Void) {
        completion(healthStoreAuthorization)
    }

    func authorizeHealthStore(_ completion: @escaping (HealthStoreAuthorization) -> Void) {
        healthStoreAuthorization = .determined
        completion(healthStoreAuthorization)
    }

    // BluetoothProvider

    var bluetoothAuthorization: BluetoothAuthorization = .notDetermined

    var bluetoothState: BluetoothState = .unknown

    func authorizeBluetooth(_ completion: (BluetoothAuthorization) -> Void) {
        bluetoothAuthorization = .authorized
        bluetoothState = .poweredOn
        completion(bluetoothAuthorization)
    }

    private var bluetoothObservers = WeakSynchronizedSet<BluetoothObserver>()

    func addBluetoothObserver(_ observer: BluetoothObserver, queue: DispatchQueue) {
        bluetoothObservers.insert(observer, queue: queue)
    }

    func removeBluetoothObserver(_ observer: BluetoothObserver) {
        bluetoothObservers.removeElement(observer)
    }

    // CGMManagerProvider

    var activeCGMManager: CGMManager? = nil
    var availableCGMManagers: [CGMManagerDescriptor] = []
    func setupCGMManager(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CGMManagerCreateNotifying & CGMManagerOnboardNotifying & CompletionNotifying, CGMManager>, Error> {
        .failure(DemoError())
    }

    // CGMManagerCreateDelegate

    func cgmManagerCreateNotifying(didCreateCGMManager cgmManager: CGMManagerUI) {
        self.activeCGMManager = cgmManager
    }

    // CGMManagerOnboardDelegate

    func cgmManagerOnboardNotifying(didOnboardCGMManager cgmManager: CGMManagerUI) {}

    // PumpManagerProvider

    var activePumpManager: PumpManager? = nil
    var availablePumpManagers: [PumpManagerDescriptor] = []
    func setupPumpManager(withIdentifier identifier: String, initialSettings settings: PumpManagerSetupSettings) -> Result<SetupUIResult<UIViewController & CompletionNotifying & PumpManagerCreateNotifying & PumpManagerOnboardNotifying, PumpManager>, Error> {
        .failure(DemoError())
    }

    // PumpManagerCreateDelegate

    func pumpManagerCreateNotifying(didCreatePumpManager pumpManager: PumpManagerUI) {
        self.activePumpManager = pumpManager
    }

    // PumpManagerOnboardDelegate

    func pumpManagerOnboardNotifying(didOnboardPumpManager pumpManager: PumpManagerUI, withFinalSettings settings: PumpManagerSetupSettings) {}

    // ServiceProvider

    var activeServices: [Service] = []
    var availableServices: [ServiceDescriptor] = []
    func setupService(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CompletionNotifying & ServiceCreateNotifying & ServiceOnboardNotifying, Service>, Error> {
        .failure(DemoError())
    }

    // ServiceCreateDelegate

    func serviceCreateNotifying(didCreateService service: Service) {
        activeServices.append(service)
    }

    // ServiceCreateDelegate

    func serviceOnboardNotifying(didOnboardService service: Service) {}

    // DeviceOrientationController

    var supportedInterfaceOrientations = UIInterfaceOrientationMask.allButUpsideDown
    func setDefaultSupportedInferfaceOrientations() {
        supportedInterfaceOrientations = UIInterfaceOrientationMask.allButUpsideDown
    }

    // CompletionDelegate

    func completionNotifyingDidComplete(_ object: CompletionNotifying) {
        self.isComplete = true
    }
}

fileprivate struct DemoError: Error {}

fileprivate extension UserDefaults {
    private enum Key: String {
        case onboardingRawState = "org.tidepool.TidepoolOnboardingDemo.OnboardingRawState"
    }

    var onboardingRawState: OnboardingUI.RawState? {
        get { object(forKey: Key.onboardingRawState.rawValue) as? OnboardingUI.RawState }
        set { set(newValue, forKey: Key.onboardingRawState.rawValue) }
    }
}
