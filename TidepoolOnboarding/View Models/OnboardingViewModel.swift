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

let TidepoolServiceIdentifier = "TidepoolService"

class OnboardingViewModel: ObservableObject, CGMManagerOnboarding, PumpManagerOnboarding, ServiceOnboarding {
    weak var cgmManagerOnboardingDelegate: CGMManagerOnboardingDelegate?
    weak var pumpManagerOnboardingDelegate: PumpManagerOnboardingDelegate?
    weak var serviceOnboardingDelegate: ServiceOnboardingDelegate?

    let onboardingProvider: OnboardingProvider

    @Published var lastAccessDate: Date
    @Published var sectionProgression: OnboardingSectionProgression
    @Published var tidepoolService: Service?
    @Published var prescription: Prescription?
    @Published var therapySettings: TherapySettings?
    @Published var dosingEnabled: Bool

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.lastAccessDate = onboarding.lastAccessDate
        self.sectionProgression = onboarding.sectionProgression
        self.tidepoolService = onboardingProvider.activeServices.first { $0.serviceIdentifier == TidepoolServiceIdentifier }
        self.prescription = onboarding.prescription
        self.therapySettings = onboarding.therapySettings
        self.dosingEnabled = onboarding.dosingEnabled ?? true

        $lastAccessDate
            .dropFirst()
            .sink { onboarding.lastAccessDate = $0 }
            .store(in: &cancellables)
        $sectionProgression
            .dropFirst()
            .sink { onboarding.sectionProgression = $0 }
            .store(in: &cancellables)
        $sectionProgression
            .dropFirst()
            .filter { $0.hasCompletedSection(.yourSettings) && !$0.hasStartedSection(.yourDevices) }
            .sink { [weak self] _ in
                guard let self = self else { return }
                onboarding.therapySettings = self.therapySettings
            }
            .store(in: &cancellables)
        $sectionProgression
            .dropFirst()
            .filter { $0.hasCompletedSection(.getLooping) }
            .sink { [weak self] _ in
                guard let self = self else { return }
                onboarding.dosingEnabled = self.dosingEnabled
            }
            .store(in: &cancellables)
        $prescription
            .dropFirst()
            .sink { onboarding.prescription = $0 }
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

    func stateStringForSection(_ section: OnboardingSection) -> String {
        switch sectionProgression.stateForSection(section) {
        case .completed:
            return LocalizedString("completed", comment: "Section completed")
        case .available:
            return LocalizedString("not completed, available", comment: "Section available")
        case .unavailable:
            return LocalizedString("not available", comment: "Section unavailable")
        }
    }
    
    func updateLastAccessedDate() {
        if shouldRestart {
            restart()
        }

        self.lastAccessDate = Date()
    }

    // The maximum duration from onboarding last access to now is 7 days, if greater, then restart, if possible
    private let lastAccessDurationMaximum: TimeInterval = .days(7)

    // Onboarding should restart only if it can be restarted and it wants to restart
    private var shouldRestart: Bool { canRestart && wantRestart }

    // Onboarding can be restarted only if the prescription has not yet been claimed
    private var canRestart: Bool { prescription == nil }

    // Onboarding wants to restart if it was last accessed over 7 days ago
    private var wantRestart: Bool { lastAccessDate.addingTimeInterval(lastAccessDurationMaximum) < Date() }

    private func restart() {
        self.sectionProgression = OnboardingSectionProgression()
    }

    func onboardTidepoolService() -> Result<OnboardingResult<ServiceViewController, Service>, Error> {
        return onboardingProvider.onboardService(withIdentifier: TidepoolServiceIdentifier)
    }

    // NOTE: DEBUG FEATURES - DEBUG AND TEST ONLY

    var allowDebugFeatures: Bool { onboardingProvider.allowDebugFeatures }

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
        guard allowDebugFeatures else { return }

        if !sectionProgression.hasStartedSection(section) {
            sectionProgression.startSection(section)
        }
        if !sectionProgression.hasCompletedSection(section) {
            if section == .yourSettings {
                if prescription == nil {
                    self.prescription = .mock
                }
                if therapySettings == nil {
                    self.therapySettings = .mockTherapySettings
                }
            }
            sectionProgression.completeSection(section)
        }
    }
}

extension OnboardingViewModel: CGMManagerOnboardingDelegate {
    func cgmManagerOnboarding(didCreateCGMManager cgmManager: CGMManagerUI) {
        cgmManagerOnboardingDelegate?.cgmManagerOnboarding(didCreateCGMManager: cgmManager)
    }

    func cgmManagerOnboarding(didOnboardCGMManager cgmManager: CGMManagerUI) {
        cgmManagerOnboardingDelegate?.cgmManagerOnboarding(didOnboardCGMManager: cgmManager)
    }
}

extension OnboardingViewModel: PumpManagerOnboardingDelegate {
    func pumpManagerOnboarding(didCreatePumpManager pumpManager: PumpManagerUI) {
        pumpManagerOnboardingDelegate?.pumpManagerOnboarding(didCreatePumpManager: pumpManager)
    }

    func pumpManagerOnboarding(didOnboardPumpManager pumpManager: PumpManagerUI, withFinalSettings settings: PumpManagerSetupSettings) {
        pumpManagerOnboardingDelegate?.pumpManagerOnboarding(didOnboardPumpManager: pumpManager, withFinalSettings: settings)
    }
}

extension OnboardingViewModel: ServiceOnboardingDelegate {
    func serviceOnboarding(didCreateService service: Service) {
        serviceOnboardingDelegate?.serviceOnboarding(didCreateService: service)

        if service.serviceIdentifier == TidepoolServiceIdentifier {
            self.tidepoolService = service
        }
    }

    func serviceOnboarding(didOnboardService service: Service) {
        serviceOnboardingDelegate?.serviceOnboarding(didOnboardService: service)
    }
}
