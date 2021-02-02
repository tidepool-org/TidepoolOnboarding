//
//  TidepoolOnboardingUI.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 12/14/20.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import HealthKit
import SwiftUI
import LoopKit
import LoopKitUI
import TidepoolOnboardingKit

public final class TidepoolOnboardingUI: OnboardingUI {
    public let onboardingIdentifier = "TidepoolOnboarding"

    public static func createOnboarding() -> OnboardingUI {
        return TidepoolOnboardingUI()
    }

    public func onboardingViewController(preferredGlucoseUnit: HKUnit, cgmManagerProvider: CGMManagerProvider, pumpManagerProvider: PumpManagerProvider, serviceProvider: ServiceProvider, colorPalette: LoopUIColorPalette) -> OnboardingViewController {
        return PrescriptionReviewUICoordinator(preferredGlucoseUnit: preferredGlucoseUnit, cgmManagerProvider: cgmManagerProvider, pumpManagerProvider: pumpManagerProvider, serviceProvider: serviceProvider, colorPalette: colorPalette)
    }
}
