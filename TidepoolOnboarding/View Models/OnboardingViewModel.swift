//
//  OnboardingViewModel.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation
import Combine
import UIKit
import LoopKit
import LoopKitUI
import TidepoolKit
import TidepoolServiceKit

let TidepoolServiceIdentifier = "TidepoolService"

class OnboardingViewModel: ObservableObject, CGMManagerOnboarding, PumpManagerOnboarding, ServiceOnboarding {
    weak var cgmManagerOnboardingDelegate: CGMManagerOnboardingDelegate?
    weak var pumpManagerOnboardingDelegate: PumpManagerOnboardingDelegate?
    weak var serviceOnboardingDelegate: ServiceOnboardingDelegate?

    let onboardingProvider: OnboardingProvider

    @Published var lastAccessDate: Date
    @Published var sectionProgression: OnboardingSectionProgression
    @Published var tidepoolService: TidepoolService?
    @Published var prescription: TPrescription?
    @Published var prescriberProfile: TProfile?
    @Published var therapySettings: TherapySettings?
    @Published var dosingEnabled: Bool

    lazy var initialTherapySettingsViewModel: TherapySettingsViewModel = constructInitialTherapySettingsViewModel()
    lazy var currentTherapySettingsViewModel: TherapySettingsViewModel = constructCurrentTherapySettingsViewModel()

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.lastAccessDate = onboarding.lastAccessDate
        self.sectionProgression = onboarding.sectionProgression
        self.tidepoolService = onboardingProvider.activeServices.first { $0.serviceIdentifier == TidepoolServiceIdentifier } as? TidepoolService
        self.prescription = onboarding.prescription
        self.prescriberProfile = onboarding.prescriberProfile
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
        $prescription
            .dropFirst()
            .sink { onboarding.prescription = $0 }
            .store(in: &cancellables)
        $prescriberProfile
            .dropFirst()
            .sink { onboarding.prescriberProfile = $0 }
            .store(in: &cancellables)
        $therapySettings
            .dropFirst()
            .sink { onboarding.therapySettings = $0 }
            .store(in: &cancellables)
        $dosingEnabled
            .dropFirst()
            .sink { onboarding.dosingEnabled = $0 }
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

    func claimPrescription(accessCode: String, birthday: Date, completion: @escaping (Error?) -> Void) {
        guard prescription == nil else {
            completion(nil)
            return
        }
        guard let tidepoolService = tidepoolService else {
            completion(OnboardingError.unexpectedState)
            return
        }

        let prescriptionClaim = TPrescriptionClaim(accessCode: accessCode, birthday: birthday)
        tidepoolService.tapi.claimPrescription(prescriptionClaim: prescriptionClaim) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(error.onboardingError)
                case .success(let prescription):
                    self.prescription = prescription
                    completion(nil)
                }
            }
        }
    }

    func getPrescriberProfile(completion: @escaping (Error?) -> Void) {
        guard prescriberProfile == nil else {
            completion(nil)
            return
        }
        guard let tidepoolService = tidepoolService, let prescription = prescription else {
            completion(OnboardingError.unexpectedState)
            return
        }

        tidepoolService.tapi.getProfile(userId: prescription.prescriberUserId) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    // completion(error.onboardingError)
                    // TODO: https://tidepool.atlassian.net/browse/LOOP-3475
                    // The backend does not *yet* automatically create a sharing connection between the prescriber account
                    // and the prescription account. This API call will fail unless the two accounts had a previous
                    // sharing connection. To allow onboarding to function, create a placeholder prescriber profile.
                    self.prescriberProfile = TProfile(fullName: "Unknown Prescriber")
                    completion(nil)
                case .success(let profile):
                    self.prescriberProfile = profile
                    completion(nil)
                }
            }
        }
    }

    private func constructInitialTherapySettingsViewModel() -> TherapySettingsViewModel {
        guard let datePrescribed = prescription?.modifiedTime ?? prescription?.createdTime,   // TODO: https://tidepool.atlassian.net/browse/LOOP-3476
              let providerName = prescriberProfile?.fullName,
              let therapySettings = prescription?.therapySettings else {
            preconditionFailure("Must have prescription and prescriber profile to construct therapy settings view model")
        }

        let prescription = OnboardingPrescription(datePrescribed: datePrescribed, providerName: providerName)
        return TherapySettingsViewModel(therapySettings: therapySettings,
                                        supportedInsulinModelSettings: supportedInsulinModelSettings,
                                        pumpSupportedIncrements: { self.pumpSupportedIncrements },
                                        prescription: prescription)
    }

    private func constructCurrentTherapySettingsViewModel() -> TherapySettingsViewModel {
        if therapySettings == nil {
            guard let therapySettings = prescription?.therapySettings else {
                preconditionFailure("Must have prescription to construct therapy settings view model")
            }

            self.therapySettings = therapySettings
        }

        return TherapySettingsViewModel(therapySettings: therapySettings!,
                                        supportedInsulinModelSettings: supportedInsulinModelSettings,
                                        pumpSupportedIncrements: { self.pumpSupportedIncrements },
                                        didSave: { (_, therapySettings) in self.therapySettings = therapySettings })
    }

    private let supportedInsulinModelSettings = SupportedInsulinModelSettings(fiaspModelEnabled: false, walshModelEnabled: false)

    private var pumpSupportedIncrements: PumpSupportedIncrements {

        // TODO: https://tidepool.atlassian.net/browse/LOOP-3112
        // Pull from pump type specified by prescription

        let supportedBasalRates: [Double] = (1...600).map { round(Double($0) / Double(1/0.05) * 100) / 100 }
        let maximumBasalScheduleEntryCount = 24
        let supportedBolusVolumes: [Double] = (1...600).map { Double($0) / Double(1/0.05) }
        return PumpSupportedIncrements(basalRates: supportedBasalRates,
                                       bolusVolumes: supportedBolusVolumes,
                                       maximumBasalScheduleEntryCount: maximumBasalScheduleEntryCount)
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
                    self.therapySettings = prescription?.therapySettings
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
            self.tidepoolService = service as? TidepoolService
        }
    }

    func serviceOnboarding(didOnboardService service: Service) {
        serviceOnboardingDelegate?.serviceOnboarding(didOnboardService: service)
    }
}

enum OnboardingError: LocalizedError {
    case unexpectedState
    case networkFailure
    case authenticationFailure
    case resourceNotFound

    var errorDescription: String? {
        switch self {
        case .unexpectedState:
            return LocalizedString("An unexpected state occurred.", comment: "Error description for an unexpected state.")
        case .networkFailure:
            return LocalizedString("A network error occurred.", comment: "Error description for a network failure.")
        case .authenticationFailure:
            return LocalizedString("An authentication error occurred.", comment: "Error description for an authentication failure.")
        case .resourceNotFound:
            return LocalizedString("A network error occurred.", comment: "Error description for a resource not found.")
        }
    }
}

fileprivate extension TError {
    var onboardingError: OnboardingError {
        switch self {
        case .requestNotAuthenticated:
            return .authenticationFailure
        case .requestResourceNotFound:
            return .resourceNotFound
        default:
            return .networkFailure
        }
    }
}

fileprivate struct OnboardingPrescription: Prescription {
    let datePrescribed: Date
    let providerName: String
}

fileprivate extension TPrescriptionClaim {
    init(accessCode: String, birthday: Date) {
        self.init(accessCode: accessCode, birthday: Self.birthdayFormatter.string(from: birthday))
    }

    private static let birthdayFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        return dateFormatter
    }()
}

