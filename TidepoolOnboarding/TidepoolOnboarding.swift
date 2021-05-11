//
//  TidepoolOnboarding.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 12/14/20.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Combine
import HealthKit
import LoopKit
import LoopKitUI
import TidepoolKit

public final class TidepoolOnboarding: ObservableObject, OnboardingUI {
    public static func createOnboarding() -> OnboardingUI {
        return Self()
    }

    public weak var onboardingDelegate: OnboardingDelegate?

    public let onboardingIdentifier = "TidepoolOnboarding"

    var lastAccessDate: Date {
        didSet {
            notifyDidUpdateState()
        }
    }

    var sectionProgression: OnboardingSectionProgression {
        didSet {
            notifyDidUpdateState()
            notifyHasNewTherapySettingsIfAvailable()
            notifyHasNewDosingEnabledIfAvailable()
            updateIsOnboarded()
        }
    }

    var prescription: TPrescription? {
        didSet {
            notifyDidUpdateState()
        }
    }

    var prescriberProfile: TProfile? {
        didSet {
            notifyDidUpdateState()
        }
    }

    var therapySettings: TherapySettings? {
        didSet {
            notifyDidUpdateState()
        }
    }

    var dosingEnabled: Bool? {
        didSet {
            notifyDidUpdateState()
        }
    }

    public init() {
        self.lastAccessDate = Date()
        self.sectionProgression = OnboardingSectionProgression()

        self.isOnboarded = false
    }

    public init?(rawState: RawState) {
        guard let lastAccessDate = rawState["lastAccessDate"] as? Date,
              let rawSectionProgression = rawState["sectionProgression"] as? OnboardingSectionProgression.RawValue,
              let sectionProgression = OnboardingSectionProgression(rawValue: rawSectionProgression) else {
            return nil
        }

        self.lastAccessDate = lastAccessDate
        self.sectionProgression = sectionProgression

        if let rawPrescription = rawState["prescription"] as? Data {
            self.prescription = try? Self.decoder.decode(TPrescription.self, from: rawPrescription)
        }
        if let rawPrescriberProfile = rawState["prescriberProfile"] as? Data {
            self.prescriberProfile = try? Self.decoder.decode(TProfile.self, from: rawPrescriberProfile)
        }
        if let rawTherapySettings = rawState["therapySettings"] as? Data {
            self.therapySettings = try? Self.decoder.decode(TherapySettings.self, from: rawTherapySettings)
        }
        self.dosingEnabled = rawState["dosingEnabled"] as? Bool

        self.isOnboarded = sectionProgression.hasCompletedAllSections
    }

    public var rawState: RawState {
        var rawState: RawState = [
            "lastAccessDate": lastAccessDate,
            "sectionProgression": sectionProgression.rawValue
        ]

        if let prescription = prescription {
            rawState["prescription"] = try? Self.encoder.encode(prescription)
        }
        if let prescriberProfile = prescriberProfile {
            rawState["prescriberProfile"] = try? Self.encoder.encode(prescriberProfile)
        }
        if let therapySettings = therapySettings {
            rawState["therapySettings"] = try? Self.encoder.encode(therapySettings)
        }
        rawState["dosingEnabled"] = dosingEnabled

        return rawState
    }

    @Published public var isOnboarded: Bool

    public func onboardingViewController(onboardingProvider: OnboardingProvider, displayGlucoseUnitObservable: DisplayGlucoseUnitObservable, colorPalette: LoopUIColorPalette) -> OnboardingViewController {
        return OnboardingRootNavigationController(onboarding: self, onboardingProvider: onboardingProvider, displayGlucoseUnitObservable: displayGlucoseUnitObservable, colorPalette: colorPalette)
    }

    private func notifyDidUpdateState() {
        onboardingDelegate?.onboardingDidUpdateState(self)
    }

    private func notifyHasNewTherapySettingsIfAvailable() {
        guard let therapySettings = therapySettings,
              sectionProgression.hasCompletedSection(.yourSettings),
              !sectionProgression.hasStartedSection(.yourDevices)
        else {
            return
        }
        onboardingDelegate?.onboarding(self, hasNewTherapySettings: therapySettings)
    }

    private func notifyHasNewDosingEnabledIfAvailable() {
        guard let dosingEnabled = dosingEnabled,
              sectionProgression.hasCompletedSection(.getLooping)
        else {
            return
        }
        onboardingDelegate?.onboarding(self, hasNewDosingEnabled: dosingEnabled)
    }

    private func updateIsOnboarded() {
        self.isOnboarded = sectionProgression.hasCompletedAllSections
    }

    public func reset() {
        self.dosingEnabled = nil
        self.therapySettings = nil
        self.prescriberProfile = nil
        self.prescription = nil
        self.sectionProgression = OnboardingSectionProgression()
        self.lastAccessDate = Date()
    }

    private static var encoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return encoder
    }()

    private static var decoder = PropertyListDecoder()
}
