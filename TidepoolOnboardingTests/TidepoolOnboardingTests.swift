//
//  TidepoolOnboardingTests.swift
//  TidepoolOnboardingTests
//
//  Created by Darin Krauss on 3/12/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
import LoopKit
import LoopKitUI
@testable import TidepoolOnboarding

class TidepoolOnboardingTests: XCTestCase {
    var didUpdateStateExpectation: XCTestExpectation?
    var hasNewTherapySettingsExpectation: XCTestExpectation?
    var hasNewDosingEnabledExpectation: XCTestExpectation?

    func testCreateOnboarding() {
        XCTAssertNotNil(TidepoolOnboarding.createOnboarding())
    }

    func testSectionProgressionNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.sectionProgression.startSection(.welcome)

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testSectionProgressionCompletionUpdatesIsOnboarded() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")
        didUpdateStateExpectation?.expectedFulfillmentCount = 14

        let onboarding = TidepoolOnboarding()
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

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.therapySettings = TherapySettings(insulinModelSettings: .exponentialPreset(.humalogNovologAdult))

        wait(for: [hasNewTherapySettingsExpectation!], timeout: 1)
    }

    func testNewDosingEnabledNotifiesDelegateOfNewDosingEnabled() {
        hasNewDosingEnabledExpectation = expectation(description: "HasNewDosingEnabled")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.dosingEnabled = true

        wait(for: [hasNewDosingEnabledExpectation!], timeout: 1)
    }
}

extension TidepoolOnboardingTests: OnboardingDelegate {
    func onboardingDidUpdateState(_ onboarding: OnboardingUI) {
        didUpdateStateExpectation?.fulfill()
    }

    func onboarding(_ onboarding: OnboardingUI, hasNewTherapySettings therapySettings: TherapySettings) {
        hasNewTherapySettingsExpectation?.fulfill()
    }

    func onboarding(_ onboarding: OnboardingUI, hasNewDosingEnabled dosingEnabled: Bool) {
        hasNewDosingEnabledExpectation?.fulfill()
    }
}
