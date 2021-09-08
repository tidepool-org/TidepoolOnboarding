//
//  OnboardingViewModel.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation
import Combine
import os.log
import DeviceCheck
import HealthKit
import UIKit
import LoopKit
import LoopKitUI
import MockKit
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
    @Published var deviceValid: Bool?
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
    @Published var criticalAlertAllowed: Bool?
    @Published var notificationAllowed: Bool?
    @Published var healthStoreAuthorization: HealthStoreAuthorization?
    @Published var cgmManagerIdentifier: String?
    @Published var pumpManagerIdentifier: String? {
        didSet {
            self.pumpSupportedIncrements = nil
        }
    }
    @Published var dosingEnabled: Bool?

    @Published var isSuspended: Bool
    @Published var isCGMManagerOnboarded: Bool
    @Published var isPumpManagerOnboarded: Bool

    lazy var initialTherapySettingsViewModel: TherapySettingsViewModel = constructInitialTherapySettingsViewModel()
    lazy var currentTherapySettingsViewModel: TherapySettingsViewModel = constructCurrentTherapySettingsViewModel()

    private var pumpSupportedIncrements: PumpSupportedIncrements?

    private let log = OSLog(category: "OnboardingViewModel")

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.lastAccessDate = onboarding.lastAccessDate
        self.sectionProgression = onboarding.sectionProgression
        self.tidepoolService = onboardingProvider.activeServices.first { $0.serviceIdentifier == TidepoolServiceIdentifier } as? TidepoolService
        self.deviceValid = onboarding.deviceValid
        self.prescription = onboarding.prescription
        self.prescriberProfile = onboarding.prescriberProfile
        self.therapySettings = onboarding.therapySettings
        self.notificationAuthorization = onboarding.notificationAuthorization
        self.criticalAlertAllowed = onboarding.criticalAlertAllowed
        self.notificationAllowed = onboarding.notificationAllowed
        self.healthStoreAuthorization = onboarding.healthStoreAuthorization
        self.cgmManagerIdentifier = onboarding.cgmManagerIdentifier
        self.pumpManagerIdentifier = onboarding.pumpManagerIdentifier
        self.dosingEnabled = onboarding.dosingEnabled

        self.isSuspended = false
        self.isCGMManagerOnboarded = onboardingProvider.activeCGMManager?.isOnboarded ?? false
        self.isPumpManagerOnboarded = onboardingProvider.activePumpManager?.isOnboarded ?? false

        $lastAccessDate
            .dropFirst()
            .sink { onboarding.lastAccessDate = $0 }
            .store(in: &cancellables)
        $sectionProgression
            .dropFirst()
            .sink { onboarding.sectionProgression = $0 }
            .store(in: &cancellables)
        $deviceValid
            .dropFirst()
            .sink { onboarding.deviceValid = $0 }
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
        $criticalAlertAllowed
            .dropFirst()
            .sink { onboarding.criticalAlertAllowed = $0 }
            .store(in: &cancellables)
        $notificationAllowed
            .dropFirst()
            .sink { onboarding.notificationAllowed = $0 }
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

        $isSuspended
            .filter { $0 }
            .sink { _ in onboarding.notifyDidSuspend() }
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

    func verifyDevice(completion: @escaping (OnboardingError?) -> Void) {
        guard deviceValid == nil else {
            log.info("%{public}@ Device already validated [deviceValid=%{public}@]", #function, deviceValid == true ? "true" : "false")
            completion(nil)
            return
        }

        guard let tidepoolService = tidepoolService else {
            log.info("%{public}@ TidepoolService is missing", #function)
            completion(OnboardingError.unexpectedState)
            return
        }

        // If the device does not require verification (i.e. simulator), mark as valid
        guard deviceRequiresVerification else {
            log.info("%{public}@ Device verification not required", #function)
            self.deviceValid = true
            completion(nil)
            return
        }

        guard !JailbrokenDeviceDetector.isJailbrokenDevice() else {
            log.info("%{public}@ Device jailbroken", #function)
            self.deviceValid = false
            completion(nil)
            return
        }

        // if the device does not support DCDevice API, mark as invalid
        guard DCDevice.current.isSupported else {
            log.info("%{public}@ DCDevice API not supported, device token cannot be generated, validation failure", #function)
            self.deviceValid = false
            completion(nil)
            return
        }

        DCDevice.current.generateToken { token, error in
            DispatchQueue.main.async {
                guard error == nil, let token = token else {
                    self.log.info("%{public}@ Device token generation failed [error=%{public}@]", #function, error.debugDescription)
                    completion(OnboardingError.unexpectedError)
                    return
                }

                tidepoolService.tapi.verifyDevice(deviceToken: token) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .failure(let error):
                            completion(error.onboardingError)
                        case .success(let deviceValid):
                            self.deviceValid = deviceValid
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    private var deviceRequiresVerification: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return true
        #endif
    }

    func claimPrescription(accessCode: String, birthday: Date, completion: @escaping (OnboardingError?) -> Void) {
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

    func getPrescriberProfile(completion: @escaping (OnboardingError?) -> Void) {
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
                                        pumpSupportedIncrements: getPumpSupportedIncrements,
                                        prescription: prescription)
    }

    private func constructCurrentTherapySettingsViewModel() -> TherapySettingsViewModel {
        guard let therapySettings = therapySettings else {
            preconditionFailure("Must have therapy settings to construct therapy settings view model")
        }

        return TherapySettingsViewModel(therapySettings: therapySettings,
                                        pumpSupportedIncrements: getPumpSupportedIncrements,
                                        didSave: { (_, therapySettings) in self.therapySettings = therapySettings })
    }

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

    func updateNotificationSettings(_ completion: @escaping () -> Void) {
        guard criticalAlertAllowed != true || notificationAllowed != true else {
            completion()
            return
        }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.criticalAlertAllowed = settings.criticalAlertSetting != .disabled
                self.notificationAllowed = settings.alertSetting != .disabled
                completion()
            }
        }
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

    func onboardCGMManager() -> Result<OnboardingResult<CGMManagerViewController, CGMManager>, Error> {
        guard let cgmManagerIdentifier = cgmManagerIdentifier else {
            return .failure(OnboardingError.unexpectedState)
        }
        let result = onboardingProvider.onboardCGMManager(withIdentifier: cgmManagerIdentifier)
        if case .success(let success) = result, case .createdAndOnboarded = success {
            self.isCGMManagerOnboarded = true
        }
        return result
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

    func onboardPumpManager() -> Result<OnboardingResult<PumpManagerViewController, PumpManager>, Error> {
        guard let pumpManagerIdentifier = pumpManagerIdentifier else {
            return .failure(OnboardingError.unexpectedState)
        }
        let result = onboardingProvider.onboardPumpManager(withIdentifier: pumpManagerIdentifier, initialSettings: pumpManagerInitialSettings)
        if case .success(let success) = result, case .createdAndOnboarded = success {
            self.isPumpManagerOnboarded = true
        }
        return result
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

    func skipAllSections(forceSimulators: Bool = false, completion: @escaping (() -> Void) = {}) {
        skipSections(forceSimulators: forceSimulators, completion: completion)
    }

    func skipThroughSection(_ section: OnboardingSection, forceSimulators: Bool = false, completion: @escaping (() -> Void) = {}) {
        skipSections(untilSection: section.next, forceSimulators: forceSimulators, completion: completion)
    }

    func skipUntilSection(_ section: OnboardingSection, forceSimulators: Bool = false, completion: @escaping (() -> Void) = {}) {
        skipSections(untilSection: section, forceSimulators: forceSimulators, completion: completion)
    }

    private func skipSections(fromSection: OnboardingSection = .welcome, untilSection: OnboardingSection? = nil, forceSimulators: Bool, completion: @escaping () -> Void) {
        dispatchPrecondition(condition: .onQueue(.main))

        guard allowDebugFeatures else {
            completion()
            return
        }

        skipSection(fromSection, forceSimulators: forceSimulators) {
            guard let nextSection = fromSection.next, nextSection != untilSection else {
                completion()
                return
            }
            self.skipSections(fromSection: nextSection, untilSection: untilSection, forceSimulators: forceSimulators, completion: completion)
        }
    }

    private func skipSection(_ section: OnboardingSection, forceSimulators: Bool, completion: @escaping () -> Void) {
        if !sectionProgression.hasStartedSection(section) {
            sectionProgression.startSection(section)
        }

        guard !sectionProgression.hasCompletedSection(section) else {
            completion()
            return
        }

        let completion = {
            self.sectionProgression.completeSection(section)
            completion()
        }

        switch section {
        case .yourSettings:
            skipCompleteYourSettings(completion: completion)
        case .yourDevices:
            skipCompleteYourDevices(forceSimulators: forceSimulators, completion: completion)
        case .getLooping:
            skipCompleteGetLooping(completion: completion)
        default:
            completion()
        }
    }

    private func skipCompleteYourSettings(completion: @escaping () -> Void) {
        self.deviceValid = true
        if prescription == nil {
            self.prescription = .mock
        }
        if prescriberProfile == nil {
            self.prescriberProfile = .mock
        }
        if therapySettings == nil {
            self.therapySettings = prescription?.therapySettings
        }

        completion()
    }

    private func skipCompleteYourDevices(forceSimulators: Bool, completion: @escaping () -> Void) {
        self.skipCompleteYourDevicesNotification {
            self.skipCompleteYourDevicesHealthStore {
                self.skipCompleteYourDevicesDevices(forceSimulators: forceSimulators, completion: completion)
            }
        }
    }

    private func skipCompleteYourDevicesNotification(completion: @escaping () -> Void) {
        guard notificationAuthorization == nil || notificationAuthorization == .notDetermined else {
            completion()
            return
        }

        onboardingProvider.authorizeNotification { _ in
            DispatchQueue.main.async {
                self.notificationAuthorization = .authorized
                self.criticalAlertAllowed = true
                self.notificationAllowed = true
                completion()
            }
        }
    }

    private func skipCompleteYourDevicesHealthStore(completion: @escaping () -> Void) {
        guard healthStoreAuthorization == nil || healthStoreAuthorization == .notDetermined else {
            completion()
            return
        }

        onboardingProvider.authorizeHealthStore { _ in
            DispatchQueue.main.async {
                self.healthStoreAuthorization = .determined
                completion()
            }
        }
    }

    private func skipCompleteYourDevicesDevices(forceSimulators: Bool, completion: @escaping () -> Void) {
        guard forceSimulators else {
            completion()
            return
        }

        if onboardingProvider.activeCGMManager == nil {
            self.cgmManagerIdentifier = MockCGMManager.managerIdentifier
            switch onboardCGMManager() {
            case .success(let result):
                switch result {
                case .userInteractionRequired(_):
                    log.error("%{public}@ Unable to force CGM simulator onboarding when user interaction required", #function)
                case .createdAndOnboarded(let cgmManager):
                    if let cgmManager = cgmManager as? MockCGMManager {
                        let parameters = MockCGMDataSource.Model.SineCurveParameters(baseGlucose: HKQuantity(unit: .milligramsPerDeciliter, doubleValue: 120),
                                                                                     amplitude: HKQuantity(unit:.milligramsPerDeciliter, doubleValue: 40),
                                                                                     period: .hours(6),
                                                                                     referenceDate: Date())
                        cgmManager.dataSource = MockCGMDataSource(model: .sineCurve(parameters: parameters))
                        cgmManager.backfillData(datingBack: .hours(3))
                    }
                }
            case .failure(let error):
                log.error("%{public}@ Failure to force CGM simulator onboarding [error=%{public}@]", #function, String(describing: error))
            }
        }

        if onboardingProvider.activePumpManager == nil {
            self.pumpManagerIdentifier = MockPumpManager.managerIdentifier
            switch onboardPumpManager() {
            case .success(let result):
                switch result {
                case .userInteractionRequired(_):
                    log.error("%{public}@ Unable to force pump simulator onboarding when user interaction required", #function)
                case .createdAndOnboarded(_):
                    break
                }
            case .failure(let error):
                log.error("%{public}@ Failure to force pump simulator onboarding [error=%{public}@]", #function, String(describing: error))
            }
        }

        completion()
    }

    private func skipCompleteGetLooping(completion: @escaping () -> Void) {
        if dosingEnabled == nil {
            self.dosingEnabled = true
        }

        completion()
    }
}

extension OnboardingViewModel: CGMManagerOnboardingDelegate {
    func cgmManagerOnboarding(didCreateCGMManager cgmManager: CGMManagerUI) {
        cgmManagerOnboardingDelegate?.cgmManagerOnboarding(didCreateCGMManager: cgmManager)
    }

    func cgmManagerOnboarding(didOnboardCGMManager cgmManager: CGMManagerUI) {
        cgmManagerOnboardingDelegate?.cgmManagerOnboarding(didOnboardCGMManager: cgmManager)
        self.isCGMManagerOnboarded = true
    }
}

extension OnboardingViewModel: PumpManagerOnboardingDelegate {
    func pumpManagerOnboarding(didCreatePumpManager pumpManager: PumpManagerUI) {
        pumpManagerOnboardingDelegate?.pumpManagerOnboarding(didCreatePumpManager: pumpManager)
    }

    func pumpManagerOnboarding(didOnboardPumpManager pumpManager: PumpManagerUI) {
        pumpManagerOnboardingDelegate?.pumpManagerOnboarding(didOnboardPumpManager: pumpManager)
        self.isPumpManagerOnboarded = true
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

fileprivate extension OnboardingSection {
    var next: OnboardingSection? {
        switch self {
        case .welcome:
            return .introduction
        case .introduction:
            return .howTheAppWorks
        case .howTheAppWorks:
            return .aDayInTheLife
        case .aDayInTheLife:
            return .yourSettings
        case .yourSettings:
            return .yourDevices
        case .yourDevices:
            return .getLooping
        case .getLooping:
            return nil
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
