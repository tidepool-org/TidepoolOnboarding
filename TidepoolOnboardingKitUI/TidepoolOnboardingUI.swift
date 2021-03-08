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

    public func onboardingViewController(cgmManagerProvider: CGMManagerProvider, pumpManagerProvider: PumpManagerProvider, serviceProvider: ServiceProvider, displayGlucoseUnit: HKUnit, colorPalette: LoopUIColorPalette) -> (UIViewController & OnboardingViewController) {
        return OnboardingRootViewController(cgmManagerProvider: cgmManagerProvider, pumpManagerProvider: pumpManagerProvider, serviceProvider: serviceProvider, displayGlucoseUnit: displayGlucoseUnit, colorPalette: colorPalette)
    }
}
