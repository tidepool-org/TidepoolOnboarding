//
//  OnboardingRootView.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI

struct OnboardingRootView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        if !onboardingViewModel.isWelcomeComplete {
            OnboardingWelcomeTabView()
                .environment(\.complete, { onboardingViewModel.isWelcomeComplete = true })
        } else {
            PrescriptionReviewView(hasNewTherapySettings: { onboardingViewModel.therapySettings = $0 })
                .environment(\.complete, { onboardingViewModel.isTherapySettingsComplete = true })
                .onAppear {
                    ensureAuthorization {}
                }
        }
    }

    private func ensureAuthorization(_ completion: @escaping () -> Void) {
        authorizeNotification {
            authorizeHealthStore {
                authorizeBluetooth(completion)
            }
        }
    }

    private func authorizeNotification(_ completion: @escaping () -> Void) {
        onboardingViewModel.onboardingProvider.getNotificationAuthorization { authorization in
            guard authorization == .notDetermined else {
                completion()
                return
            }
            onboardingViewModel.onboardingProvider.authorizeNotification { _ in completion() }
        }
    }

    private func authorizeHealthStore(_ completion: @escaping () -> Void) {
        onboardingViewModel.onboardingProvider.getHealthStoreAuthorization { authorization in
            guard authorization == .notDetermined else {
                completion()
                return
            }
            onboardingViewModel.onboardingProvider.authorizeHealthStore { _ in completion() }
        }
    }

    private func authorizeBluetooth(_ completion: @escaping () -> Void) {
        guard onboardingViewModel.onboardingProvider.bluetoothAuthorization == .notDetermined else {
            completion()
            return
        }
        onboardingViewModel.onboardingProvider.authorizeBluetooth { _ in completion() }
    }
}

struct OnboardingRootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreview {
            OnboardingRootView()
                .environmentObject(OnboardingViewModel.preview)
                .environmentObject(PreferredGlucoseUnit.preview)
        }
    }
}

extension OnboardingViewModel {
    static var preview: OnboardingViewModel {
        return OnboardingViewModel(onboarding: TidepoolOnboardingUI(), onboardingProvider: PreviewOnboardingProvider())
    }
}

extension PreferredGlucoseUnit {
    static var preview: PreferredGlucoseUnit {
        return PreferredGlucoseUnit(.milligramsPerDeciliter)
    }
}

class PreviewOnboardingProvider: OnboardingProvider {
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
        .failure(PreviewError())
    }

    var activePumpManager: PumpManager? = nil
    var availablePumpManagers: [PumpManagerDescriptor] = []
    func setupPumpManager(withIdentifier identifier: String, initialSettings settings: PumpManagerSetupSettings) -> Result<SetupUIResult<UIViewController & CompletionNotifying & PumpManagerCreateNotifying & PumpManagerOnboardNotifying, PumpManager>, Error> {
        .failure(PreviewError())
    }

    var activeServices: [Service] = []
    var availableServices: [ServiceDescriptor] = []
    func setupService(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CompletionNotifying & ServiceCreateNotifying & ServiceOnboardNotifying, Service>, Error> {
        .failure(PreviewError())
    }
}

struct PreviewError: Error {}
