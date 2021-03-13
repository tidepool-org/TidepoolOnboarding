//
//  MockOnboardingProvider.swift
//  TidepoolOnboardingKitUITests
//
//  Created by Darin Krauss on 3/12/21.
//

import LoopKit
import LoopKitUI

class MockOnboardingProvider: OnboardingProvider {
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
    func setupCGMManager(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CGMManagerCreateNotifying & CGMManagerOnboardNotifying & CompletionNotifying, CGMManager>, Error> {
        .failure(MockError())
    }

    var activePumpManager: PumpManager? = nil
    var availablePumpManagers: [PumpManagerDescriptor] = []
    func setupPumpManager(withIdentifier identifier: String, initialSettings settings: PumpManagerSetupSettings) -> Result<SetupUIResult<UIViewController & CompletionNotifying & PumpManagerCreateNotifying & PumpManagerOnboardNotifying, PumpManager>, Error> {
        .failure(MockError())
    }

    var activeServices: [Service] = []
    var availableServices: [ServiceDescriptor] = []
    func setupService(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CompletionNotifying & ServiceCreateNotifying & ServiceOnboardNotifying, Service>, Error> {
        .failure(MockError())
    }
}

fileprivate struct MockError: Error {}
