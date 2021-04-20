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
import TidepoolOnboarding
import TidepoolServiceKit
import TidepoolServiceKitUI

class DemoViewModel: ObservableObject, OnboardingProvider, OnboardingDelegate, CGMManagerOnboardingDelegate, PumpManagerOnboardingDelegate, ServiceOnboardingDelegate, CompletionDelegate, DeviceOrientationController {
    let onboarding: TidepoolOnboarding

    @Published var isComplete: Bool = false

    init() {
        if let onboardingRawState = UserDefaults.standard.onboardingRawState,
           let onboarding = TidepoolOnboarding(rawState: onboardingRawState) {
            self.onboarding = onboarding
        } else {
            self.onboarding = TidepoolOnboarding()
        }

        // If fully onboarded then reset (to avoid delete/resintall)
        if onboarding.isOnboarded {
            onboarding.reset()
        }

        onboarding.onboardingDelegate = self
    }

    // OnboardingProvider

    var allowDebugFeatures: Bool = true

    // OnboardingDelegate

    func onboardingDidUpdateState(_ onboarding: OnboardingUI) {
        UserDefaults.standard.onboardingRawState = onboarding.rawState
    }

    func onboarding(_ onboarding: OnboardingUI, hasNewTherapySettings therapySettings: TherapySettings) {}

    func onboarding(_ onboarding: OnboardingUI, hasNewDosingEnabled dosingEnabled: Bool) {}

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
    func onboardCGMManager(withIdentifier identifier: String) -> Result<OnboardingResult<CGMManagerViewController, CGMManager>, Error> {
        .failure(DemoError())
    }

    // CGMManagerOnboardingDelegate

    func cgmManagerOnboarding(didCreateCGMManager cgmManager: CGMManagerUI) {
        self.activeCGMManager = cgmManager
    }
    func cgmManagerOnboarding(didOnboardCGMManager cgmManager: CGMManagerUI) {}

    // PumpManagerProvider

    var activePumpManager: PumpManager? = nil
    var availablePumpManagers: [PumpManagerDescriptor] = []
    func onboardPumpManager(withIdentifier identifier: String, initialSettings settings: PumpManagerSetupSettings) -> Result<OnboardingResult<PumpManagerViewController, PumpManager>, Error> {
        .failure(DemoError())
    }

    // PumpManagerOnboardingDelegate

    func pumpManagerOnboarding(didCreatePumpManager pumpManager: PumpManagerUI) {
        self.activePumpManager = pumpManager
    }
    func pumpManagerOnboarding(didOnboardPumpManager pumpManager: PumpManagerUI, withFinalSettings settings: PumpManagerSetupSettings) {}

    // ServiceProvider

    var activeServices: [Service] = []
    var availableServices: [ServiceDescriptor] = [ServiceDescriptor(identifier: TidepoolService.serviceIdentifier, localizedTitle: TidepoolService.localizedTitle)]
    func onboardService(withIdentifier identifier: String) -> Result<OnboardingResult<ServiceViewController, Service>, Error> {
        guard let service = activeServices.first(where: { $0.serviceIdentifier == identifier }) else {
            switch identifier {
            case TidepoolService.serviceIdentifier:
                switch TidepoolService.setupViewController(colorPalette: .demo) {
                case .userInteractionRequired(let viewController):
                    return .success(.userInteractionRequired(viewController))
                case .createdAndOnboarded(let service):
                    return .success(.createdAndOnboarded(service))
                }
            default:
                return .failure(DemoError())
            }
        }

        if service.isOnboarded {
            return .success(.createdAndOnboarded(service))
        }

        guard let serviceUI = service as? ServiceUI else {
            return .failure(DemoError())
        }

        return .success(.userInteractionRequired(serviceUI.settingsViewController(colorPalette: .demo)))
    }

    // ServiceOnboardingDelegate

    func serviceOnboarding(didCreateService service: Service) {
        activeServices.append(service)
    }
    func serviceOnboarding(didOnboardService service: Service) {}

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
