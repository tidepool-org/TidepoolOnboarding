//
//  TidepoolOnboarding+UI.swift
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

extension TidepoolOnboarding: OnboardingUI {
    public func onboardingViewController(preferredGlucoseUnit: HKUnit, cgmManagerProvider: CGMManagerProvider, pumpManagerProvider: PumpManagerProvider, serviceProvider: ServiceProvider, colorPalette: LoopUIColorPalette) -> (UIViewController & OnboardingNotifying & CGMManagerCreateNotifying & CGMManagerOnboardNotifying & PumpManagerCreateNotifying & PumpManagerOnboardNotifying & ServiceCreateNotifying & ServiceOnboardNotifying & CompletionNotifying) {
        return PrescriptionReviewUICoordinator(preferredGlucoseUnit: preferredGlucoseUnit, cgmManagerProvider: cgmManagerProvider, pumpManagerProvider: pumpManagerProvider, serviceProvider: serviceProvider, colorPalette: colorPalette)
    }
}
