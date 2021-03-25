//
//  OnboardingViewModel.swift
//  TidepoolOnboarding
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
    @Published var dosingEnabled: Bool

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.sectionProgression = onboarding.sectionProgression
        self.therapySettings = onboarding.therapySettings
        self.dosingEnabled = onboarding.dosingEnabled ?? true

        $sectionProgression
            .dropFirst()
            .sink { onboarding.sectionProgression = $0 }
            .store(in: &cancellables)
        $sectionProgression
            .dropFirst()
            .filter { $0.hasCompletedSection(.yourSettings) && !$0.hasStartedSection(.yourDevices) }
            .sink { _ in onboarding.therapySettings = self.therapySettings }
            .store(in: &cancellables)
        $sectionProgression
            .dropFirst()
            .filter { $0.hasCompletedSection(.getLooping) }
            .sink { _ in onboarding.dosingEnabled = self.dosingEnabled }
            .store(in: &cancellables)
    }

    func titleForSection(_ section: OnboardingSection) -> String {
        switch section {
        case .welcome:
            return LocalizedString("Welcome", comment: "Onboarding, Welcome section, button title")
        case .introduction:
            return LocalizedString("Introduction", comment: "Onboarding, Introduction section, button title")
        case .howTheAppWorks:
            return LocalizedString("How the App Works", comment: "Onboarding, How the App Works section, button title")
        case .aDayInTheLife:
            return LocalizedString("A Day in the Life", comment: "Onboarding, A Day in the Life section, button title")
        case .yourSettings:
            return LocalizedString("Your Settings", comment: "Onboarding, Your Settings section, button title")
        case .yourDevices:
            return LocalizedString("Your Devices", comment: "Onboarding, Your Devices section, button title")
        case .getLooping:
            return LocalizedString("Get Looping", comment: "Onboarding, Get Looping section, button title")
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
        return String(format: LocalizedString("%d min.", comment: "Section duration label (1: section duration in minutes)"), Int(durationForSection(section).minutes))
    }

    // NOTE: SKIP ONBOARDING - DEBUG AND TEST ONLY

    var allowSkipOnboarding: Bool { onboardingProvider.allowSkipOnboarding }

    func skipAllSections() {
        OnboardingSection.allCases.forEach { skipSection($0) }
    }

    func skipThroughSection(_ section: OnboardingSection) {
        skipUntilSection(section)
        skipSection(section)
    }

    func skipUntilSection(_ section: OnboardingSection) {
        OnboardingSection.allCases.prefix(while: { $0 != section }).forEach { skipSection($0) }
    }

    func skipSection(_ section: OnboardingSection) {
        guard allowSkipOnboarding else { return }

        if !sectionProgression.hasStartedSection(section) {
            sectionProgression.startSection(section)
        }
        if !sectionProgression.hasCompletedSection(section) {
            if section == .yourSettings {
                self.therapySettings = .mockTherapySettings     // If therapy settings not completed, then use mock therapy settings
            }
            sectionProgression.completeSection(section)
        }
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
