//
//  PrescriptionReviewViewController.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct PrescriptionReviewViewController: UIViewControllerRepresentable {
    @EnvironmentObject var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable
    @Environment(\.colorPalette) var colorPalette: LoopUIColorPalette

    private let onboardingDelegate: OnboardingDelegate
    private let completionDelegate: CompletionDelegate

    init(onboardingDelegate: OnboardingDelegate, completionDelegate: CompletionDelegate) {
        self.onboardingDelegate = onboardingDelegate
        self.completionDelegate = completionDelegate
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let prescriptionReviewUICoordinator = PrescriptionReviewUICoordinator(displayGlucoseUnitObservable: displayGlucoseUnitObservable, colorPalette: colorPalette)
        prescriptionReviewUICoordinator.onboardingDelegate = onboardingDelegate
        prescriptionReviewUICoordinator.completionDelegate = completionDelegate
        return prescriptionReviewUICoordinator
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
