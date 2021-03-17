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

    @Published var sectionProgression: OnboardingSectionProgression
    @Published var therapySettings: TherapySettings?

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboardingUI, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.sectionProgression = onboarding.sectionProgression
        self.therapySettings = onboarding.therapySettings

        $sectionProgression
            .dropFirst()
            .sink { onboarding.sectionProgression = $0 }
            .store(in: &cancellables)
        $therapySettings
            .dropFirst()
            .sink { onboarding.therapySettings = $0 }
            .store(in: &cancellables)
    }

    func titleForSection(_ section: OnboardingSection) -> String {
        switch section {
        case .welcome:
            return LocalizedString("Welcome", comment: "Title for Welcome onboarding section")
        case .introduction:
            return LocalizedString("Introduction", comment: "Title for Introduction onboarding section")
        case .howTheAppWorks:
            return LocalizedString("How the App Works", comment: "Title for How the App Works onboarding section")
        case .aDayInTheLife:
            return LocalizedString("A Day in the Life", comment: "Title for A Day in the Life onboarding section")
        case .yourSettings:
            return LocalizedString("Your Settings", comment: "Title for Your Settings onboarding section")
        case .yourDevices:
            return LocalizedString("Your Devices", comment: "Title for Your Devices onboarding section")
        case .getLooping:
            return LocalizedString("Get Looping", comment: "Title for Get Looping onboarding section")
        }
    }

    func durationForSection(_ section: OnboardingSection) -> TimeInterval {
        switch section {
        case .welcome:
            return .minutes(5)
        case .introduction:
            return .minutes(5)
        case .howTheAppWorks:
            return .minutes(15)
        case .aDayInTheLife:
            return .minutes(10)
        case .yourSettings:
            return .minutes(10)
        case .yourDevices:
            return .minutes(15)
        case .getLooping:
            return .minutes(5)
        }
    }

    func durationStringForSection(_ section: OnboardingSection) -> String {
        return String(format: LocalizedString("%d min.", comment: "Section duration with minutes units (1: section duration in minutes)"), Int(durationForSection(section).minutes))
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
