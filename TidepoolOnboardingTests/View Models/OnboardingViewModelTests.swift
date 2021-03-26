//
//  OnboardingViewModelTests.swift
//  TidepoolOnboardingTests
//
//  Created by Darin Krauss on 3/12/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
import LoopKit
@testable import TidepoolOnboarding

class OnboardingViewModelTests: XCTestCase {
    var onboarding: TidepoolOnboarding!
    var onboardingViewModel: OnboardingViewModel!

    override func setUp() {
        onboarding = TidepoolOnboarding()
        onboarding.sectionProgression.startSection(.welcome)
        onboarding.therapySettings = TherapySettings(insulinModelSettings: .exponentialPreset(.humalogNovologAdult))
        onboarding.dosingEnabled = false
        onboardingViewModel = OnboardingViewModel(onboarding: onboarding, onboardingProvider: MockOnboardingProvider())
    }

    func testSectionProgressInitialization() {
        XCTAssertEqual(onboardingViewModel.sectionProgression, onboarding.sectionProgression)
    }

    func testSectionProgressForwarding() {
        onboardingViewModel.sectionProgression.completeSection(.welcome)
        XCTAssertEqual(onboarding.sectionProgression, onboardingViewModel.sectionProgression)
    }

    func testTherapySettingsInitialization() {
        XCTAssertEqual(onboardingViewModel.therapySettings, onboarding.therapySettings)
    }

    func testTherapySettingsForwarding() {
        onboardingViewModel.therapySettings = TherapySettings(insulinModelSettings: .exponentialPreset(.fiasp))
        XCTAssertNotEqual(onboarding.therapySettings, onboardingViewModel.therapySettings)
        onboardingViewModel.skipUntilSection(.yourSettings)
        XCTAssertNotEqual(onboarding.therapySettings, onboardingViewModel.therapySettings)
        onboardingViewModel.skipThroughSection(.yourSettings)
        XCTAssertEqual(onboarding.therapySettings, onboardingViewModel.therapySettings)
    }

    func testDosingEnabledInitialization() {
        XCTAssertEqual(onboardingViewModel.dosingEnabled, onboarding.dosingEnabled)
    }

    func testDosingEnabledForwarding() {
        onboardingViewModel.dosingEnabled = true
        XCTAssertNotEqual(onboarding.dosingEnabled, onboardingViewModel.dosingEnabled)
        onboardingViewModel.skipUntilSection(.getLooping)
        XCTAssertNotEqual(onboarding.dosingEnabled, onboardingViewModel.dosingEnabled)
        onboardingViewModel.skipThroughSection(.getLooping)
        XCTAssertEqual(onboarding.dosingEnabled, onboardingViewModel.dosingEnabled)
    }
}
