//
//  OnboardingViewModelTests.swift
//  TidepoolOnboardingTests
//
//  Created by Darin Krauss on 3/12/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import XCTest
import TidepoolKit
import LoopKit
@testable import TidepoolOnboarding

class OnboardingViewModelTests: XCTestCase {
    var onboarding: TidepoolOnboarding!
    var onboardingViewModel: OnboardingViewModel!

    override func setUp() {
        onboarding = TidepoolOnboarding()
        onboarding.sectionProgression.startSection(.welcome)
        onboarding.prescription = .test
        onboarding.prescriberProfile = .test
        onboarding.therapySettings = .test
        onboarding.notificationAuthorization = .notDetermined
        onboarding.healthStoreAuthorization = .notDetermined
        onboarding.cgmManagerIdentifier = "CGM Manager Identifier"
        onboarding.pumpManagerIdentifier = "Pump Manager Identifier"
        onboarding.dosingEnabled = false
        onboardingViewModel = OnboardingViewModel(onboarding: onboarding, onboardingProvider: MockOnboardingProvider())
    }

    func testlastAccessDateInitialization() {
        XCTAssertEqual(onboardingViewModel.lastAccessDate, onboarding.lastAccessDate)
    }

    func testlastAccessDateForwarding() {
        onboardingViewModel.lastAccessDate = Date()
        XCTAssertEqual(onboarding.lastAccessDate, onboardingViewModel.lastAccessDate)
    }

    func testSectionProgressionInitialization() {
        XCTAssertEqual(onboardingViewModel.sectionProgression, onboarding.sectionProgression)
    }

    func testSectionProgressionForwarding() {
        onboardingViewModel.sectionProgression.completeSection(.welcome)
        XCTAssertEqual(onboarding.sectionProgression, onboardingViewModel.sectionProgression)
    }

    func testPrescriptionInitialization() {
        XCTAssertEqual(onboardingViewModel.prescription, onboarding.prescription)
    }

    func testPrescriptionForwarding() {
        onboardingViewModel.prescription = TPrescription(id: "abcdef")
        XCTAssertEqual(onboarding.prescription, onboardingViewModel.prescription)
    }

    func testPrescriptionSetsTherapySettings() {
        onboarding.therapySettings = nil
        onboardingViewModel.prescription = .mock
        XCTAssertNotNil(onboarding.therapySettings)
    }

    func testPrescriptionSetsCGMManagerIdentifier() {
        onboarding.cgmManagerIdentifier = nil
        onboardingViewModel.prescription = .mock
        XCTAssertNotNil(onboarding.cgmManagerIdentifier)
    }

    func testPrescriptionSetsPumpManagerIdentifier() {
        onboarding.pumpManagerIdentifier = nil
        onboardingViewModel.prescription = .mock
        XCTAssertNotNil(onboarding.pumpManagerIdentifier)
    }

    func testPrescriberProfileInitialization() {
        XCTAssertEqual(onboardingViewModel.prescriberProfile, onboarding.prescriberProfile)
    }

    func testPrescriberProfileForwarding() {
        onboardingViewModel.prescriberProfile = TProfile(fullName: "Forwarding Test")
        XCTAssertEqual(onboarding.prescriberProfile, onboardingViewModel.prescriberProfile)
    }

    func testTherapySettingsInitialization() {
        XCTAssertEqual(onboardingViewModel.therapySettings, onboarding.therapySettings)
    }

    func testTherapySettingsForwarding() {
        onboardingViewModel.therapySettings = TherapySettings(insulinModelSettings: .exponentialPreset(.fiasp))
        XCTAssertEqual(onboarding.therapySettings, onboardingViewModel.therapySettings)
    }

    func testNotificationAuthorizationInitialization() {
        XCTAssertEqual(onboardingViewModel.notificationAuthorization, onboarding.notificationAuthorization)
    }

    func testNotificationAuthorizationForwarding() {
        onboardingViewModel.notificationAuthorization = .authorized
        XCTAssertEqual(onboarding.notificationAuthorization, onboardingViewModel.notificationAuthorization)
    }

    func testHealthStoreAuthorizationInitialization() {
        XCTAssertEqual(onboardingViewModel.healthStoreAuthorization, onboarding.healthStoreAuthorization)
    }

    func testHealthStoreAuthorizationForwarding() {
        onboardingViewModel.healthStoreAuthorization = .determined
        XCTAssertEqual(onboarding.healthStoreAuthorization, onboardingViewModel.healthStoreAuthorization)
    }

    func testCGMManagerIdentifierInitialization() {
        XCTAssertEqual(onboardingViewModel.cgmManagerIdentifier, onboarding.cgmManagerIdentifier)
    }

    func testCGMManagerIdentifierForwarding() {
        onboardingViewModel.cgmManagerIdentifier = "New CGM Manager Identifier"
        XCTAssertEqual(onboarding.cgmManagerIdentifier, onboardingViewModel.cgmManagerIdentifier)
    }

    func testPumpManagerIdentifierInitialization() {
        XCTAssertEqual(onboardingViewModel.pumpManagerIdentifier, onboarding.pumpManagerIdentifier)
    }

    func testPumpManagerIdentifierForwarding() {
        onboardingViewModel.pumpManagerIdentifier = "New Pump Manager Identifier"
        XCTAssertEqual(onboarding.pumpManagerIdentifier, onboardingViewModel.pumpManagerIdentifier)
    }

    func testDosingEnabledInitialization() {
        XCTAssertEqual(onboardingViewModel.dosingEnabled, onboarding.dosingEnabled)
    }

    func testDosingEnabledForwarding() {
        onboardingViewModel.dosingEnabled = true
        XCTAssertEqual(onboarding.dosingEnabled, onboardingViewModel.dosingEnabled)
    }

    func testUpdateLastAccessedDateUpdatesDate() {
        let lastAccessDate = onboardingViewModel.lastAccessDate
        onboardingViewModel.updateLastAccessedDate()
        XCTAssertNotEqual(onboardingViewModel.lastAccessDate, lastAccessDate)
    }

    func testUpdateLastAccessDateRestartsWithoutPrescriptionAndPastDate() {
        onboardingViewModel.prescription = nil
        onboardingViewModel.lastAccessDate = Date().addingTimeInterval(.days(-7)).addingTimeInterval(.seconds(-5))
        XCTAssertTrue(onboardingViewModel.sectionProgression.isStarted)
        onboardingViewModel.updateLastAccessedDate()
        XCTAssertFalse(onboardingViewModel.sectionProgression.isStarted)
    }

    func testUpdateLastAccessDateDoesNotRestartsWithPrescriptionAndPastDate() {
        onboardingViewModel.lastAccessDate = Date().addingTimeInterval(.days(-7)).addingTimeInterval(.seconds(-5))
        XCTAssertTrue(onboardingViewModel.sectionProgression.isStarted)
        onboardingViewModel.updateLastAccessedDate()
        XCTAssertTrue(onboardingViewModel.sectionProgression.isStarted)
    }

    func testUpdateLastAccessDateDoesNotRestartsWithoutPrescriptionAndNotPastDate() {
        onboardingViewModel.prescription = nil
        onboardingViewModel.lastAccessDate = Date().addingTimeInterval(.days(-7)).addingTimeInterval(.seconds(5))
        XCTAssertTrue(onboardingViewModel.sectionProgression.isStarted)
        onboardingViewModel.updateLastAccessedDate()
        XCTAssertTrue(onboardingViewModel.sectionProgression.isStarted)
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
