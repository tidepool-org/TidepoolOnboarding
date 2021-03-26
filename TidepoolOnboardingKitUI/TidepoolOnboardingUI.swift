//
//  TidepoolOnboardingUI.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 12/14/20.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Combine
import HealthKit
import LoopKit
import LoopKitUI
import TidepoolOnboardingKit

public final class TidepoolOnboardingUI: ObservableObject, OnboardingUI {
    public static func createOnboarding() -> OnboardingUI {
        return Self()
    }

    public weak var onboardingDelegate: OnboardingDelegate?

    public let onboardingIdentifier = "TidepoolOnboarding"

    var sectionProgression: OnboardingSectionProgression {
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
        self.sectionProgression = OnboardingSectionProgression()

        self.isOnboarded = false
    }

    public init?(rawState: RawState) {
        guard let rawSectionProgression = rawState["sectionProgression"] as? OnboardingSectionProgression.RawValue,
              let sectionProgression = OnboardingSectionProgression(rawValue: rawSectionProgression) else {
            return nil
        }

        self.sectionProgression = sectionProgression

        self.isOnboarded = sectionProgression.hasCompletedAllSections
    }

    public var rawState: RawState {
        return [
            "sectionProgression": sectionProgression.rawValue
        ]
    }

    @Published public var isOnboarded: Bool

    public func onboardingViewController(onboardingProvider: OnboardingProvider, displayGlucoseUnitObservable: DisplayGlucoseUnitObservable, colorPalette: LoopUIColorPalette) -> (UIViewController & OnboardingViewController) {
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
        self.sectionProgression = OnboardingSectionProgression()
        self.therapySettings = nil
        self.isOnboarded = false
    }
}
