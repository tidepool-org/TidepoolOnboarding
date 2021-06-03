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
    @Published var prescription: TPrescription? {
        didSet {
            self.therapySettings = prescription?.therapySettings
            self.cgmManagerIdentifier = prescription?.cgmManagerIdentifier
            self.pumpManagerIdentifier = prescription?.pumpManagerIdentifier
        }
    }
    @Published var prescriberProfile: TProfile?
    @Published var therapySettings: TherapySettings?
    @Published var notificationAuthorization: NotificationAuthorization?
    @Published var healthStoreAuthorization: HealthStoreAuthorization?
    @Published var cgmManagerIdentifier: String?
    @Published var pumpManagerIdentifier: String? {
        didSet {
            self.pumpSupportedIncrements = nil
        }
    }
    @Published var dosingEnabled: Bool?

    lazy var initialTherapySettingsViewModel: TherapySettingsViewModel = constructInitialTherapySettingsViewModel()
    lazy var currentTherapySettingsViewModel: TherapySettingsViewModel = constructCurrentTherapySettingsViewModel()

    private var pumpSupportedIncrements: PumpSupportedIncrements?

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.lastAccessDate = onboarding.lastAccessDate
        self.sectionProgression = onboarding.sectionProgression
        self.tidepoolService = onboardingProvider.activeServices.first { $0.serviceIdentifier == TidepoolServiceIdentifier } as? TidepoolService
        self.prescription = onboarding.prescription
        self.prescriberProfile = onboarding.prescriberProfile
        self.therapySettings = onboarding.therapySettings
        self.notificationAuthorization = onboarding.notificationAuthorization
        self.healthStoreAuthorization = onboarding.healthStoreAuthorization
        self.cgmManagerIdentifier = onboarding.cgmManagerIdentifier
        self.pumpManagerIdentifier = onboarding.pumpManagerIdentifier
        self.dosingEnabled = onboarding.dosingEnabled

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
        $notificationAuthorization
            .dropFirst()
            .sink { onboarding.notificationAuthorization = $0 }
            .store(in: &cancellables)
        $healthStoreAuthorization
            .dropFirst()
            .sink { onboarding.healthStoreAuthorization = $0 }
            .store(in: &cancellables)
        $cgmManagerIdentifier
            .dropFirst()
            .sink { onboarding.cgmManagerIdentifier = $0 }
            .store(in: &cancellables)
        $pumpManagerIdentifier
            .dropFirst()
            .sink { onboarding.pumpManagerIdentifier = $0 }
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
                                        pumpSupportedIncrements: getPumpSupportedIncrements,
                                        prescription: prescription)
    }

    private func constructCurrentTherapySettingsViewModel() -> TherapySettingsViewModel {
        guard let therapySettings = therapySettings else {
            preconditionFailure("Must have therapy settings to construct therapy settings view model")
        }

        return TherapySettingsViewModel(therapySettings: therapySettings,
                                        supportedInsulinModelSettings: supportedInsulinModelSettings,
                                        pumpSupportedIncrements: getPumpSupportedIncrements,
                                        didSave: { (_, therapySettings) in self.therapySettings = therapySettings })
    }

    private let supportedInsulinModelSettings = SupportedInsulinModelSettings(fiaspModelEnabled: false, walshModelEnabled: false)

    private func getPumpSupportedIncrements() -> PumpSupportedIncrements? {
        guard pumpSupportedIncrements == nil else {
            return pumpSupportedIncrements
        }
        guard let pumpManagerIdentifier = pumpManagerIdentifier else {
            return nil
        }
        self.pumpSupportedIncrements = onboardingProvider.supportedIncrementsForPumpManager(withIdentifier: pumpManagerIdentifier)
        return pumpSupportedIncrements
    }

    var cgmManagerTitle: String {
        guard let cgmManagerIdentifier = cgmManagerIdentifier,
              let cgmManagerDescriptor = onboardingProvider.availableCGMManagers.first(where: { $0.identifier == cgmManagerIdentifier }) else {
                return LocalizedString("Unknown CGM", comment: "Unknown CGM manager title")
        }
        return cgmManagerDescriptor.localizedTitle
    }

    var cgmManagerImage: UIImage {
        guard let cgmManagerIdentifier = cgmManagerIdentifier,
              let cgmManagerImage = onboardingProvider.imageForCGMManager(withIdentifier: cgmManagerIdentifier) else {
            return UIColor.clear.image()
        }
        return cgmManagerImage
    }

    var isCGMManagerOnboarded: Bool {
        guard let activeCGMManager = onboardingProvider.activeCGMManager,
              activeCGMManager.managerIdentifier == cgmManagerIdentifier else {
            return false
        }
        return activeCGMManager.isOnboarded
    }

    func onboardCGMManager() -> Result<OnboardingResult<CGMManagerViewController, CGMManager>, Error> {
        guard let cgmManagerIdentifier = cgmManagerIdentifier else {
            return .failure(OnboardingError.unexpectedState)
        }
        return onboardingProvider.onboardCGMManager(withIdentifier: cgmManagerIdentifier)
    }

    var pumpManagerTitle: String {
        guard let pumpManagerIdentifier = pumpManagerIdentifier,
              let pumpManagerDescriptor = onboardingProvider.availablePumpManagers.first(where: { $0.identifier == pumpManagerIdentifier }) else {
            return LocalizedString("Unknown Pump", comment: "Unknown pump manager title")
        }
        return pumpManagerDescriptor.localizedTitle
    }

    var pumpManagerImage: UIImage {
        guard let pumpManagerIdentifier = pumpManagerIdentifier,
              let pumpManagerImage = onboardingProvider.imageForPumpManager(withIdentifier: pumpManagerIdentifier) else {
            return UIColor.clear.image()
        }
        return pumpManagerImage
    }

    var isPumpManagerOnboarded: Bool {
        guard let activePumpManager = onboardingProvider.activePumpManager,
              activePumpManager.managerIdentifier == pumpManagerIdentifier else {
            return false
        }
        return activePumpManager.isOnboarded
    }

    func onboardPumpManager() -> Result<OnboardingResult<PumpManagerViewController, PumpManager>, Error> {
        guard let pumpManagerIdentifier = pumpManagerIdentifier else {
            return .failure(OnboardingError.unexpectedState)
        }
        return onboardingProvider.onboardPumpManager(withIdentifier: pumpManagerIdentifier,
                                                     initialSettings: pumpManagerInitialSettings)
    }

    private var pumpManagerInitialSettings: PumpManagerSetupSettings {
        guard let therapySettings = therapySettings else {
            preconditionFailure("Must have therapy settings to construct pump manager initial settings")
        }

        return PumpManagerSetupSettings(maxBasalRateUnitsPerHour: therapySettings.maximumBasalRatePerHour,
                                        maxBolusUnits: therapySettings.maximumBolus,
                                        basalSchedule: therapySettings.basalRateSchedule)
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

    private func skipSection(_ section: OnboardingSection) {
        guard allowDebugFeatures else { return }

        if !sectionProgression.hasStartedSection(section) {
            sectionProgression.startSection(section)
        }
        if !sectionProgression.hasCompletedSection(section) {
            if section == .yourSettings {
                if prescription == nil {
                    self.prescription = .mock
                }
                if prescriberProfile == nil {
                    self.prescriberProfile = .mock
                }
                if therapySettings == nil {
                    self.therapySettings = prescription?.therapySettings
                }
            } else if section == .yourDevices {
                if notificationAuthorization == nil || notificationAuthorization == .notDetermined {
                    self.notificationAuthorization = .authorized
                    onboardingProvider.authorizeNotification { _ in }
                }
                if healthStoreAuthorization == nil || healthStoreAuthorization == .notDetermined {
                    self.healthStoreAuthorization = .determined
                    onboardingProvider.authorizeHealthStore { _ in }
                }
            } else if section == .getLooping {
                if dosingEnabled == nil {
                    self.dosingEnabled = true
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

fileprivate extension TPrescription {
    var cgmManagerIdentifier: String? {
        switch latestRevision?.attributes?.initialSettings?.cgmId {
        case "d25c3f1b-a2e8-44e2-b3a3-fd07806fc245":    // Hard-coded Tidepool backend device identifier
            return "DexcomCGM"
        default:
            return nil
        }
    }

    var pumpManagerIdentifier: String? {
        switch latestRevision?.attributes?.initialSettings?.pumpId {
        case "6678c377-928c-49b3-84c1-19e2dafaff8d":    // Hard-coded Tidepool backend device identifier
            return "OmnipodDash"
        default:
            return nil
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
