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
import CryptoKit
import HealthKit
import UIKit
import LoopTestingKit
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

    var presentModal: ((UIViewController) -> Void)?
    var dismissCurrentModal: (() -> Void)?

    @Published var lastAccessDate: Date
    @Published var sectionProgression: OnboardingSectionProgression
    @Published var tidepoolService: TidepoolService?
    @Published var deviceValid: Bool?
    @Published var appValid: Bool?
    @Published var attestationKeyID: String?
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
    @Published var timeSensitiveNotificationAllowed: Bool?
    @Published var healthStoreAuthorization: HealthStoreAuthorization?
    @Published var cgmManagerIdentifier: String?
    @Published var pumpManagerIdentifier: String? {
        didSet {
            self._pumpSupportedIncrements = nil
        }
    }
    @Published var dosingEnabled: Bool?

    @Published var isSuspended: Bool
    @Published var isCGMManagerOnboarded: Bool
    @Published var isPumpManagerOnboarded: Bool

    lazy var initialTherapySettingsViewModel: TherapySettingsViewModel = constructInitialTherapySettingsViewModel()
    lazy var currentTherapySettingsViewModel: TherapySettingsViewModel = constructCurrentTherapySettingsViewModel()

    private var _pumpSupportedIncrements: PumpSupportedIncrements?

    private let log = OSLog(category: "OnboardingViewModel")

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider) {
        self.onboardingProvider = onboardingProvider

        self.lastAccessDate = onboarding.lastAccessDate
        self.sectionProgression = onboarding.sectionProgression
        self.tidepoolService = onboardingProvider.activeServices.first { $0.serviceIdentifier == TidepoolServiceIdentifier } as? TidepoolService
        self.deviceValid = onboarding.deviceValid
        self.appValid = onboarding.appValid
        self.attestationKeyID = onboarding.attestationKeyID
        self.prescription = onboarding.prescription
        self.prescriberProfile = onboarding.prescriberProfile
        self.therapySettings = onboarding.therapySettings
        self.notificationAuthorization = onboarding.notificationAuthorization
        self.criticalAlertAllowed = onboarding.criticalAlertAllowed
        self.notificationAllowed = onboarding.notificationAllowed
        self.timeSensitiveNotificationAllowed = onboarding.timeSensitiveNotificationAllowed
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
        $appValid
            .dropFirst()
            .sink { onboarding.appValid = $0 }
            .store(in: &cancellables)
        $attestationKeyID
            .dropFirst()
            .sink { onboarding.attestationKeyID = $0 }
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
        $timeSensitiveNotificationAllowed
            .dropFirst()
            .sink { onboarding.timeSensitiveNotificationAllowed = $0 }
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
        
        switch studyProduct {
        case .studyProduct1:
            deviceValid = true
            appValid = true
            prescription = .mock(.studyProduct1)
            prescriberProfile = .mock
        case .studyProduct2:
            deviceValid = true
            appValid = true
            prescription = .mock(.studyProduct2)
            prescriberProfile = .mock
            onboardPumpManager(prefersToSkipUserInteraction: true) { _ in }
            onboardCGMManager(prefersToSkipUserInteraction: true) { _ in }
            skipThroughSection(.getLooping)
        default:
            break
        }
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
            Task { @MainActor in
                guard error == nil, let token = token else {
                    self.log.info("%{public}@ Device token generation failed [error=%{public}@]", #function, error.debugDescription)
                    completion(OnboardingError.unexpectedError)
                    return
                }

                do {
                    let deviceValid = try await tidepoolService.tapi.verifyDevice(deviceToken: token)
                    self.deviceValid = deviceValid
                    completion(nil)
                } catch {
                    completion((error as! TError).onboardingError)
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

    func verifyApp(completion: @escaping (OnboardingError?) -> Void) {
        guard appValid == nil else {
            log.info("%{public}@ App already validated [appValid=%{public}@]", #function, appValid == true ? "true" : "false")
            completion(nil)
            return
        }

        guard let tidepoolService = tidepoolService else {
            log.info("%{public}@ TidepoolService is missing", #function)
            completion(OnboardingError.unexpectedState)
            return
        }

        // If the app does not require verification (i.e. simulator), mark as valid
        guard appRequiresVerification else {
            log.info("%{public}@ App verification not required", #function)
            self.appValid = true
            completion(nil)
            return
        }

        // if the device does not support DCAppAttestService API, mark as invalid
        let appAttestService = DCAppAttestService.shared
        guard appAttestService.isSupported else {
            log.info("%{public}@ DCAppAttestService API not supported, app key ID cannot be generated, validation failure", #function)
            self.appValid = false
            completion(nil)
            return
        }

        Task { @MainActor in
            do {
                let attestationKeyID: String
                if self.attestationKeyID != nil {
                    attestationKeyID = self.attestationKeyID!
                } else {
                    attestationKeyID = try await appAttestService.generateKey()
                }

                let challenge = try await tidepoolService.tapi.getAttestationChallenge(keyID: attestationKeyID)

                let hash = Data(SHA256.hash(data: Array(challenge.utf8)))

                let attestation = try await appAttestService.attestKey(attestationKeyID, clientDataHash: hash)

                let appValid = try await tidepoolService.tapi.verifyAttestation(keyID: attestationKeyID, challenge: challenge, attestation: attestation.base64EncodedString())

                self.appValid = appValid
                self.attestationKeyID = attestationKeyID
                completion(nil)
            } catch {
                self.log.info("%{public}@ App attestation verification failed [error=%{public}@]", #function, String(describing: error.localizedDescription))
                self.appValid = false
                self.attestationKeyID = nil
                completion((error as! TError).onboardingError)
            }
        }
    }

    private var appRequiresVerification: Bool {
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

        Task { @MainActor in
            do {
                let prescription = try await tidepoolService.tapi.claimPrescription(prescriptionClaim: prescriptionClaim)
                self.prescription = prescription
                completion(nil)
            } catch {
                completion((error as! TError).onboardingError)
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

        Task { @MainActor in
            do {
                let profile = try await tidepoolService.tapi.getProfile(userId: prescription.prescriberUserId)
                self.prescriberProfile = profile
                completion(nil)
            } catch {
                completion((error as! TError).onboardingError)
            }
        }
    }

    private func constructInitialTherapySettingsViewModel() -> TherapySettingsViewModel {
        guard let datePrescribed = prescription?.submittedTime ?? prescription?.modifiedTime ?? prescription?.createdTime,
              let providerName = prescriberProfile?.fullName,
              let therapySettings = prescription?.therapySettings else {
            preconditionFailure("Must have prescription and prescriber profile to construct therapy settings view model")
        }

        let prescription = OnboardingPrescription(datePrescribed: datePrescribed, providerName: providerName)
        return TherapySettingsViewModel(therapySettings: therapySettings,
                                        prescription: prescription,
                                        delegate: self)
    }

    private func constructCurrentTherapySettingsViewModel() -> TherapySettingsViewModel {
        guard let therapySettings = therapySettings else {
            preconditionFailure("Must have therapy settings to construct therapy settings view model")
        }
        return TherapySettingsViewModel(therapySettings: therapySettings, delegate: self)
    }

    private func getPumpSupportedIncrements() -> PumpSupportedIncrements? {
        guard _pumpSupportedIncrements == nil else {
            return _pumpSupportedIncrements
        }
        guard let pumpManagerIdentifier = pumpManagerIdentifier else {
            return nil
        }
        self._pumpSupportedIncrements = onboardingProvider.supportedIncrementsForPumpManager(withIdentifier: pumpManagerIdentifier)
        return _pumpSupportedIncrements
    }

    func updateNotificationSettings(_ completion: @escaping () -> Void) {
        guard criticalAlertAllowed != true || notificationAllowed != true || timeSensitiveNotificationAllowed != true else {
            completion()
            return
        }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.criticalAlertAllowed = settings.criticalAlertSetting != .disabled
                self.notificationAllowed = settings.alertSetting != .disabled
                if #available(iOS 15.0, *) {
                    self.timeSensitiveNotificationAllowed = settings.timeSensitiveSetting != .disabled
                } else {
                    self.timeSensitiveNotificationAllowed = true
                }
                completion()
            }
        }
    }

    var cgmManagerTitle: String {
        guard let cgmManagerIdentifier = cgmManagerIdentifier,
              let cgmManagerDescriptor = onboardingProvider.availableCGMManagers.first(where: { $0.identifier == cgmManagerIdentifier }) else {
                return LocalizedString("iCGM", comment: "Unknown CGM manager title")
        }
        return cgmManagerDescriptor.localizedTitle
    }

    var cgmManagerImage: UIImage {
        guard let cgmManagerIdentifier = cgmManagerIdentifier,
              let cgmManagerImage = onboardingProvider.imageForCGMManager(withIdentifier: cgmManagerIdentifier) else {
            return UIImage(frameworkImage: "icgm-default") ?? UIColor.clear.image()
        }
        return cgmManagerImage
    }


    func onboardCGMManager(prefersToSkipUserInteraction: Bool = false, _ completion: @escaping (Error?) -> Void) {
        guard let cgmManagerIdentifier = cgmManagerIdentifier else {
            completion(OnboardingError.unexpectedState)
            return
        }
        let result = onboardingProvider.onboardCGMManager(withIdentifier: cgmManagerIdentifier, prefersToSkipUserInteraction: prefersToSkipUserInteraction)
        switch result {
        case .success(let setupUIResult):
            switch setupUIResult {
            case .createdAndOnboarded(let cgmManager):
                if let cgmManager = cgmManager as? MockCGMManager {
                    let parameters = MockCGMDataSource.Model.SineCurveParameters(baseGlucose: HKQuantity(unit: .milligramsPerDeciliter, doubleValue: 120),
                                                                                 amplitude: HKQuantity(unit:.milligramsPerDeciliter, doubleValue: 40),
                                                                                 period: .hours(6),
                                                                                 referenceDate: Date())
                    cgmManager.dataSource = MockCGMDataSource(model: .sineCurve(parameters: parameters))
                    cgmManager.backfillData(datingBack: .hours(3))
                }
                isCGMManagerOnboarded = true
                completion(nil)
            case .userInteractionRequired(var setupVC):
                deviceManagerOnboardingCompletion = completion
                setupVC.cgmManagerOnboardingDelegate = self
                setupVC.completionDelegate = self
                presentModal?(setupVC)
            }
        case .failure(let error):
            completion(error)
        }
    }

    var pumpManagerTitle: String {
        guard let pumpManagerIdentifier = pumpManagerIdentifier,
              let pumpManagerDescriptor = onboardingProvider.availablePumpManagers.first(where: { $0.identifier == pumpManagerIdentifier }) else {
            return LocalizedString("ACE Pump", comment: "Unknown pump manager title")
        }
        return pumpManagerDescriptor.localizedTitle
    }

    var pumpManagerImage: UIImage {
        guard let pumpManagerIdentifier = pumpManagerIdentifier,
              let pumpManagerImage = onboardingProvider.imageForPumpManager(withIdentifier: pumpManagerIdentifier) else {
            return UIImage(frameworkImage: "ace-pump-default") ?? UIColor.clear.image()
        }
        return pumpManagerImage
    }

    var deviceManagerOnboardingCompletion: ((Error?) -> Void)?

    func onboardPumpManager(prefersToSkipUserInteraction: Bool = false, _ completion: @escaping (Error?) -> Void) {
        guard let pumpManagerIdentifier = pumpManagerIdentifier else {
            completion(OnboardingError.unexpectedState)
            return
        }
        let result = onboardingProvider.onboardPumpManager(withIdentifier: pumpManagerIdentifier, initialSettings: pumpManagerInitialSettings, prefersToSkipUserInteraction: prefersToSkipUserInteraction)
        switch result {
        case .success(let setupUIResult):
            switch setupUIResult {
            case .createdAndOnboarded:
                self.isPumpManagerOnboarded = true
                completion(nil)
            case .userInteractionRequired(var setupVC):
                deviceManagerOnboardingCompletion = completion
                setupVC.pumpManagerOnboardingDelegate = self
                setupVC.completionDelegate = self
                presentModal?(setupVC)
            }
        case .failure(let error):
            completion(error)
        }
    }

    private var pumpManagerInitialSettings: PumpManagerSetupSettings {
        guard let therapySettings = therapySettings,
              let maximumBasalRatePerHour = therapySettings.maximumBasalRatePerHour,
              let maximumBolus = therapySettings.maximumBolus,
              let basalRateSchedule = therapySettings.basalRateSchedule
        else {
            preconditionFailure("Must have therapy settings to construct pump manager initial settings")
        }

        return PumpManagerSetupSettings(maxBasalRateUnitsPerHour: maximumBasalRatePerHour,
                                        maxBolusUnits: maximumBolus,
                                        basalSchedule: basalRateSchedule)
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
            self.prescription = .mock()
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
                self.timeSensitiveNotificationAllowed = true
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
            skipCompleteYourDevicesCGMManager()
        }
        if onboardingProvider.activePumpManager == nil {
            skipCompleteYourDevicesPumpManager()
        }
        completion()
    }

    func skipCompleteYourDevicesCGMManager() {
        cgmManagerIdentifier = MockCGMManager.managerIdentifier
        onboardCGMManager { error in
            if let error = error {
                self.log.error("%{public}@ Failure to force CGM simulator onboarding [error=%{public}@]", #function, String(describing: error))
            } else {
                self.isCGMManagerOnboarded = true
            }
        }
    }
    
    func skipCompleteYourDevicesPumpManager() {
        self.pumpManagerIdentifier = MockPumpManager.managerIdentifier
        onboardPumpManager { error in
            if let error = error {
                self.log.error("%{public}@ Failure to force pump simulator onboarding [error=%{public}@]", #function, String(describing: error))
            } else {
                self.isPumpManagerOnboarded = true
            }
        }
    }
    
    private func skipCompleteGetLooping(completion: @escaping () -> Void) {
        if dosingEnabled == nil {
            self.dosingEnabled = true
        }

        completion()
    }
}

extension OnboardingViewModel: CompletionDelegate {
    func completionNotifyingDidComplete(_ object: CompletionNotifying) {
        if object as? PumpManagerViewController != nil || object as? CGMManagerViewController != nil {
            if let vc = object as? CGMManagerViewController {
                // only dismiss the CGMManagerViewController
                vc.dismiss(animated: true)
            } else {
                // dismiss out to the root view
                dismissCurrentModal?()
            }
            deviceManagerOnboardingCompletion?(nil)
            deviceManagerOnboardingCompletion = nil
        }
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

    func pumpManagerOnboarding(didPauseOnboarding pumpManager: PumpManagerUI) {
        self.isSuspended = true
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

extension OnboardingViewModel: TherapySettingsViewModelDelegate {
    func syncBasalRateSchedule(items: [RepeatingScheduleValue<Double>], completion: @escaping (Result<BasalRateSchedule, Error>) -> Void) {
        //noop
    }
    
    func syncDeliveryLimits(deliveryLimits: DeliveryLimits, completion: @escaping (Result<DeliveryLimits, Error>) -> Void) {
        //noop
    }
    
    func saveCompletion(therapySettings: TherapySettings) {
        // Note: the expectation is that this would only be called by the _current_ TherapySettingsView, so it should
        // be okay to just save it here.
        self.therapySettings = therapySettings
    }
    
    func pumpSupportedIncrements() -> PumpSupportedIncrements? {
        return getPumpSupportedIncrements()
    }
}

extension OnboardingViewModel {
    public enum StudyProduct: String {
        case none
        case studyProduct1
        case studyProduct2
    }
    
    public var studyProduct: StudyProduct {
        StudyProduct(rawValue: onboardingProvider.availableSupports.first?.studyProductSelection ?? "none") ?? .none
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
        case "15137627-e9ba-4bab-a36d-7c2f0a5ef368":    // Hard-coded Tidepool backend device identifier
            return "DemoDexcomCGMManager"
        default:
            return nil
        }
    }

    var pumpManagerIdentifier: String? {
        switch latestRevision?.attributes?.initialSettings?.pumpId {
        case "e4a46eda-02f9-4faf-b8f4-ef7b40d02e4f":    // Hard-coded Tidepool backend device identifier
            return "AccuChekSolo"
        case "89cc2977-bbc3-4f46-86e5-06bae8176b52":    // Hard-coded Tidepool backend device identifier
            return "SoloDemo"
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
