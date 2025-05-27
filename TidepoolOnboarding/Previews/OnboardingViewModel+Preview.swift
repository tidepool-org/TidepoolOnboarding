//
//  OnboardingViewModel+Preview.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/8/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import LoopKit
import LoopKitUI

extension OnboardingViewModel {
    static var preview: OnboardingViewModel { OnboardingViewModel(onboarding: TidepoolOnboarding(), onboardingProvider: PreviewOnboardingProvider()) }
}

fileprivate class PreviewOnboardingProvider: OnboardingProvider {
    var hostIdentifier = "1.0"
    
    var hostVersion = "org.tidepool.Loop"

    var allowDebugFeatures: Bool = true

    func getNotificationAuthorization(_ completion: @escaping (NotificationAuthorization) -> Void) { completion(.notDetermined) }
    func authorizeNotification(_ completion: @escaping (NotificationAuthorization) -> Void) { completion(.notDetermined) }

    func getHealthStoreAuthorization(_ completion: @escaping (HealthStoreAuthorization) -> Void) { completion(.notDetermined) }
    func authorizeHealthStore(_ completion: @escaping (HealthStoreAuthorization) -> Void) { completion(.notDetermined) }

    var bluetoothAuthorization: BluetoothAuthorization = .notDetermined
    var bluetoothState: BluetoothState = .unknown
    func authorizeBluetooth(_ completion: (BluetoothAuthorization) -> Void) { completion(.notDetermined) }
    func addBluetoothObserver(_ observer: BluetoothObserver, queue: DispatchQueue) {}
    func removeBluetoothObserver(_ observer: BluetoothObserver) {}

    var activeCGMManager: CGMManager? = nil
    var availableCGMManagers: [CGMManagerDescriptor] = []
    func imageForCGMManager(withIdentifier identifier: String) -> UIImage? { nil }
    func onboardCGMManager(withIdentifier identifier: String, prefersToSkipUserInteraction: Bool) -> Result<OnboardingResult<CGMManagerViewController, CGMManager>, Error> {
        .failure(PreviewError())
    }

    var activePumpManager: PumpManager? = nil
    var availablePumpManagers: [PumpManagerDescriptor] = []
    func imageForPumpManager(withIdentifier identifier: String) -> UIImage? { nil }
    func supportedIncrementsForPumpManager(withIdentifier identifier: String) -> PumpSupportedIncrements? { nil }
    func onboardPumpManager(withIdentifier identifier: String, initialSettings settings: PumpManagerSetupSettings, prefersToSkipUserInteraction: Bool) -> Result<OnboardingResult<PumpManagerViewController, PumpManager>, Error> {
        .failure(PreviewError())
    }

    var activeServices: [Service] = []
    var availableServices: [ServiceDescriptor] = []
    
    var availableSupports: [SupportUI] = []
    
    func statefulPlugin(withIdentifier identifier: String) -> StatefulPluggable? { return nil }
    
    var onboardingTherapySettings: TherapySettings {
        return TherapySettings()
    }
}

fileprivate struct PreviewError: Error {}
