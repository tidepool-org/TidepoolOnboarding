//
//  TidepoolOnboardingTests.swift
//  TidepoolOnboardingTests
//
//  Created by Darin Krauss on 3/12/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
import TidepoolKit
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

    func testLastAccessDateNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.lastAccessDate = Date()

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testSectionProgressionNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.sectionProgression.startSection(.welcome)

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testSectionProgressionWithTherapySettingsNotifiesDelegateOfTherapySettings() {
        hasNewTherapySettingsExpectation = expectation(description: "HasNewTherapySettings")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.therapySettings = .test

        onboarding.sectionProgression.startSection(.welcome)
        onboarding.sectionProgression.completeSection(.welcome)
        onboarding.sectionProgression.startSection(.introduction)
        onboarding.sectionProgression.completeSection(.introduction)
        onboarding.sectionProgression.startSection(.howTheAppWorks)
        onboarding.sectionProgression.completeSection(.howTheAppWorks)
        onboarding.sectionProgression.startSection(.aDayInTheLife)
        onboarding.sectionProgression.completeSection(.aDayInTheLife)
        onboarding.sectionProgression.startSection(.yourSettings)
        onboarding.sectionProgression.completeSection(.yourSettings)

        wait(for: [hasNewTherapySettingsExpectation!], timeout: 1)
    }

    func testSectionProgressionWithDosingEnabledNotifiesDelegateOfDosingEnabled() {
        hasNewDosingEnabledExpectation = expectation(description: "HasNewDosingEnabled")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.dosingEnabled = true

        onboarding.sectionProgression.startSection(.welcome)
        onboarding.sectionProgression.completeSection(.welcome)
        onboarding.sectionProgression.startSection(.introduction)
        onboarding.sectionProgression.completeSection(.introduction)
        onboarding.sectionProgression.startSection(.howTheAppWorks)
        onboarding.sectionProgression.completeSection(.howTheAppWorks)
        onboarding.sectionProgression.startSection(.aDayInTheLife)
        onboarding.sectionProgression.completeSection(.aDayInTheLife)
        onboarding.sectionProgression.startSection(.yourSettings)
        onboarding.sectionProgression.completeSection(.yourSettings)
        onboarding.sectionProgression.startSection(.yourDevices)
        onboarding.sectionProgression.completeSection(.yourDevices)
        onboarding.sectionProgression.startSection(.getLooping)
        onboarding.sectionProgression.completeSection(.getLooping)

        wait(for: [hasNewDosingEnabledExpectation!], timeout: 1)
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

    func testPrescriptionNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.prescription = .mock

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testPrescriberNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.prescriberProfile = .test

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testTherapySettingsNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.therapySettings = .test

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testDosingEnabledNotifiesDelegateOfUpdate() {
        didUpdateStateExpectation = expectation(description: "DidUpdateState")

        let onboarding = TidepoolOnboarding()
        onboarding.onboardingDelegate = self
        onboarding.dosingEnabled = true

        wait(for: [didUpdateStateExpectation!], timeout: 1)
    }

    func testRawState() {
        let old = TidepoolOnboarding()
        old.lastAccessDate = Date()
        old.sectionProgression.startSection(.welcome)
        old.sectionProgression.completeSection(.welcome)
        old.prescription = .test
        old.prescriberProfile = .test
        old.therapySettings = .test
        old.dosingEnabled = true

        let rawState = old.rawState
        XCTAssertNotNil(rawState["lastAccessDate"])
        XCTAssertNotNil(rawState["sectionProgression"])
        XCTAssertNotNil(rawState["prescription"])
        XCTAssertNotNil(rawState["prescriberProfile"])
        XCTAssertNotNil(rawState["therapySettings"])
        XCTAssertNotNil(rawState["dosingEnabled"])

        let new = TidepoolOnboarding(rawState: rawState)
        XCTAssertNotNil(new)
        if let new = new {
            XCTAssertEqual(new.lastAccessDate, old.lastAccessDate)
            XCTAssertEqual(new.sectionProgression, old.sectionProgression)
            XCTAssertEqual(new.prescription, old.prescription)
            XCTAssertEqual(new.prescriberProfile, old.prescriberProfile)
            XCTAssertEqual(new.therapySettings, old.therapySettings)
            XCTAssertEqual(new.dosingEnabled, old.dosingEnabled)
            XCTAssertFalse(new.isOnboarded)
        }
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

fileprivate extension TherapySettings {
    static var test: Self { .mockTherapySettings }
}

fileprivate extension TPrescription {
    static var test: Self { .mock }
}

fileprivate extension TProfile {
    static var test: Self { TProfile(fullName: "Test") }
}
