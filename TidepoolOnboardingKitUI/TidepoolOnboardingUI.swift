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

    var isWelcomeComplete: Bool {
        didSet {
            guard isWelcomeComplete != oldValue else { return }
            notifyDidUpdateState()
        }
    }
    var isTherapySettingsComplete: Bool {
        didSet {
            guard isTherapySettingsComplete != oldValue else { return }
            notifyDidUpdateState()
        }
    }

    var therapySettings: TherapySettings? {
        didSet {
            guard therapySettings != oldValue, let therapySettings = therapySettings else { return }
            notifyHasNewTherapySettings(therapySettings)
        }
    }

    init() {
        self.isWelcomeComplete = false
        self.isTherapySettingsComplete = false

        self.isOnboarded = false
    }

    public init?(rawState: RawState) {
        guard let isWelcomeComplete = rawState["isWelcomeComplete"] as? Bool,
              let isTherapySettingsComplete = rawState["isTherapySettingsComplete"] as? Bool
        else {
            return nil
        }

        self.isWelcomeComplete = isWelcomeComplete
        self.isTherapySettingsComplete = isTherapySettingsComplete

        self.isOnboarded = isWelcomeComplete && isTherapySettingsComplete
    }

    public var rawState: RawState {
        return [
            "isWelcomeComplete": isWelcomeComplete,
            "isTherapySettingsComplete": isTherapySettingsComplete
        ]
    }

    @Published public var isOnboarded: Bool

    public func onboardingViewController(onboardingProvider: OnboardingProvider, displayGlucoseUnitObservable: DisplayGlucoseUnitObservable, colorPalette: LoopUIColorPalette) -> (UIViewController & OnboardingViewController) {
        return OnboardingRootViewController(onboarding: self, onboardingProvider: onboardingProvider, displayGlucoseUnitObservable: displayGlucoseUnitObservable, colorPalette: colorPalette)
    }

    private func notifyDidUpdateState() {
        onboardingDelegate?.onboardingDidUpdateState(self)
        self.isOnboarded = isWelcomeComplete && isTherapySettingsComplete
    }

    private func notifyHasNewTherapySettings(_ therapySettings: TherapySettings) {
        onboardingDelegate?.onboarding(self, hasNewTherapySettings: therapySettings)
    }
}
