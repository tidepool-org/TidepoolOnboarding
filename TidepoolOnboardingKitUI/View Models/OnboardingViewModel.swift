//
//  OnboardingViewModel.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation
import Combine
import LoopKit
import LoopKitUI

class OnboardingViewModel: ObservableObject, CGMManagerCreateNotifying, CGMManagerOnboardNotifying, PumpManagerCreateNotifying, PumpManagerOnboardNotifying, ServiceCreateNotifying, ServiceOnboardNotifying {
    weak var cgmManagerCreateDelegate: CGMManagerCreateDelegate?
    weak var cgmManagerOnboardDelegate: CGMManagerOnboardDelegate?
    weak var pumpManagerCreateDelegate: PumpManagerCreateDelegate?
    weak var pumpManagerOnboardDelegate: PumpManagerOnboardDelegate?
    weak var serviceCreateDelegate: ServiceCreateDelegate?
    weak var serviceOnboardDelegate: ServiceOnboardDelegate?

    let onboardingProvider: OnboardingProvider

    @Published var isWelcomeComplete: Bool
    @Published var isTherapySettingsComplete: Bool
    @Published var therapySettings: TherapySettings?

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboardingUI, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.isWelcomeComplete = onboarding.isWelcomeComplete
        self.isTherapySettingsComplete = onboarding.isTherapySettingsComplete
        self.therapySettings = onboarding.therapySettings

        $isWelcomeComplete
            .dropFirst()
            .sink { onboarding.isWelcomeComplete = $0 }
            .store(in: &cancellables)
        $isTherapySettingsComplete
            .dropFirst()
            .sink { onboarding.isTherapySettingsComplete = $0 }
            .store(in: &cancellables)
        $therapySettings
            .dropFirst()
            .sink { onboarding.therapySettings = $0 }
            .store(in: &cancellables)
    }
}

extension OnboardingViewModel: CGMManagerCreateDelegate {
    func cgmManagerCreateNotifying(didCreateCGMManager cgmManager: CGMManagerUI) {
        cgmManagerCreateDelegate?.cgmManagerCreateNotifying(didCreateCGMManager: cgmManager)
    }
}

extension OnboardingViewModel: CGMManagerOnboardDelegate {
    func cgmManagerOnboardNotifying(didOnboardCGMManager cgmManager: CGMManagerUI) {
        cgmManagerOnboardDelegate?.cgmManagerOnboardNotifying(didOnboardCGMManager: cgmManager)
    }
}

extension OnboardingViewModel: PumpManagerCreateDelegate {
    func pumpManagerCreateNotifying(didCreatePumpManager pumpManager: PumpManagerUI) {
        pumpManagerCreateDelegate?.pumpManagerCreateNotifying(didCreatePumpManager: pumpManager)
    }
}

extension OnboardingViewModel: PumpManagerOnboardDelegate {
    func pumpManagerOnboardNotifying(didOnboardPumpManager pumpManager: PumpManagerUI, withFinalSettings settings: PumpManagerSetupSettings) {
        pumpManagerOnboardDelegate?.pumpManagerOnboardNotifying(didOnboardPumpManager: pumpManager, withFinalSettings: settings)
    }
}

extension OnboardingViewModel: ServiceCreateDelegate {
    func serviceCreateNotifying(didCreateService service: Service) {
        serviceCreateDelegate?.serviceCreateNotifying(didCreateService: service)
    }
}

extension OnboardingViewModel: ServiceOnboardDelegate {
    func serviceOnboardNotifying(didOnboardService service: Service) {
        serviceOnboardDelegate?.serviceOnboardNotifying(didOnboardService: service)
    }
}
