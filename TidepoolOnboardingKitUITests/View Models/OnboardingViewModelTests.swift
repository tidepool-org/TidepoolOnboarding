//
//  OnboardingViewModelTests.swift
//  TidepoolOnboardingKitUITests
//
//  Created by Darin Krauss on 3/12/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
import LoopKit
@testable import TidepoolOnboardingKitUI

class OnboardingViewModelTests: XCTestCase {
    var onboarding: TidepoolOnboardingUI!
    var onboardingViewModel: OnboardingViewModel!

    override func setUp() {
        onboarding = TidepoolOnboardingUI()
        onboarding.sectionProgression.startSection(.welcome)
        onboarding.therapySettings = TherapySettings(insulinModelSettings: .exponentialPreset(.humalogNovologAdult))
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
        XCTAssertEqual(onboarding.therapySettings, onboardingViewModel.therapySettings)
    }
}
