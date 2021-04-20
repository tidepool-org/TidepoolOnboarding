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
        }
    }

    var prescription: Prescription? {
        didSet {
            notifyDidUpdateState()
        }
    }

    var therapySettings: TherapySettings? {
        didSet {
            guard let therapySettings = therapySettings else { return }
            notifyHasNewTherapySettings(therapySettings)
        }
    }

    var dosingEnabled: Bool? {
        didSet {
            guard let dosingEnabled = dosingEnabled else { return }
            notifyHasNewDosingEnabled(dosingEnabled)
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

        if let rawPrescription = rawState["prescription"] as? Prescription.RawValue {
            self.prescription = Prescription(rawValue: rawPrescription)
        }

        self.isOnboarded = sectionProgression.hasCompletedAllSections
    }

    public var rawState: RawState {
        var rawState: RawState = [
            "lastAccessDate": lastAccessDate,
            "sectionProgression": sectionProgression.rawValue
        ]

        rawState["prescription"] = prescription?.rawValue

        return rawState
    }

    @Published public var isOnboarded: Bool

    public func onboardingViewController(onboardingProvider: OnboardingProvider, displayGlucoseUnitObservable: DisplayGlucoseUnitObservable, colorPalette: LoopUIColorPalette) -> OnboardingViewController {
        return OnboardingRootNavigationController(onboarding: self, onboardingProvider: onboardingProvider, displayGlucoseUnitObservable: displayGlucoseUnitObservable, colorPalette: colorPalette)
    }

    private func notifyDidUpdateState() {
        onboardingDelegate?.onboardingDidUpdateState(self)
        self.isOnboarded = sectionProgression.hasCompletedAllSections
    }

    private func notifyHasNewTherapySettings(_ therapySettings: TherapySettings) {
        onboardingDelegate?.onboarding(self, hasNewTherapySettings: therapySettings)
    }

    private func notifyHasNewDosingEnabled(_ dosingEnabled: Bool) {
        onboardingDelegate?.onboarding(self, hasNewDosingEnabled: dosingEnabled)
    }

    public func reset() {
        self.dosingEnabled = nil
        self.therapySettings = nil
        self.prescription = nil
        self.sectionProgression = OnboardingSectionProgression()
        self.lastAccessDate = Date()
    }
}
