//
//  TidepoolOnboardingUITests.swift
//  TidepoolOnboardingKitUITests
//
//  Created by Darin Krauss on 3/12/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
import LoopKit
import LoopKitUI
@testable import TidepoolOnboardingKitUI

class TidepoolOnboardingUITests: XCTestCase {
    var didUpdateStateExpectation: XCTestExpectation?
    var hasNewTherapySettingsExpectation: XCTestExpectation?

    func testCreateOnboarding() {
        XCTAssertNotNil(TidepoolOnboardingUI.createOnboarding())
    }

    func testSectionProgressionNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboardingUI()
        onboarding.onboardingDelegate = self
        onboarding.sectionProgression.startSection(.welcome)

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testSectionProgressionCompletionUpdatesIsOnboarded() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")
        didUpdateStateExpectation?.expectedFulfillmentCount = 14

        let onboarding = TidepoolOnboardingUI()
        onboarding.onboardingDelegate = self

        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.welcome)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.welcome)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.introduction)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.introduction)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.howTheAppWorks)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.howTheAppWorks)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.aDayInTheLife)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.aDayInTheLife)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.yourSettings)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.yourSettings)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.yourDevices)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.yourDevices)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.startSection(.getLooping)
        XCTAssertFalse(onboarding.isOnboarded)
        onboarding.sectionProgression.completeSection(.getLooping)
        XCTAssertTrue(onboarding.isOnboarded)

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testNewTherapySettingsNotifiesDelegateOfNewTherapySettings() {
        hasNewTherapySettingsExpectation = expectation(description: "HasNewTherapySettings")

        let onboarding = TidepoolOnboardingUI()
        onboarding.onboardingDelegate = self
        onboarding.therapySettings = TherapySettings(insulinModelSettings: .exponentialPreset(.humalogNovologAdult))

        wait(for: [hasNewTherapySettingsExpectation!], timeout: 1)
    }
}

extension TidepoolOnboardingUITests: OnboardingDelegate {
    func onboardingDidUpdateState(_ onboarding: OnboardingUI) {
        didUpdateStateExpectation?.fulfill()
    }

    func onboarding(_ onboarding: OnboardingUI, hasNewTherapySettings therapySettings: TherapySettings) {
        hasNewTherapySettingsExpectation?.fulfill()
    }
}
