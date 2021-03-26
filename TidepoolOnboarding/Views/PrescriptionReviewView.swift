//
//  PrescriptionReviewView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI

struct PrescriptionReviewView: UIViewControllerRepresentable {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable
    @Environment(\.colorPalette) var colorPalette: LoopUIColorPalette
    @Environment(\.complete) var complete
    @Environment(\.dismiss) var dismiss

    final class Coordinator: PrescriptionReviewDelegate, CompletionDelegate {
        private let parent: PrescriptionReviewView

        init(_ parent: PrescriptionReviewView) {
            self.parent = parent
        }

        func prescriptionReview(hasNewTherapySettings therapySettings: TherapySettings) {
            parent.onboardingViewModel.therapySettings = therapySettings
            parent.complete()
        }

        func completionNotifyingDidComplete(_ object: CompletionNotifying) {
            parent.dismiss()
        }
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let prescriptionReviewUICoordinator = PrescriptionReviewUICoordinator(displayGlucoseUnitObservable: displayGlucoseUnitObservable, colorPalette: colorPalette)
        prescriptionReviewUICoordinator.prescriptionReviewDelegate = context.coordinator
        prescriptionReviewUICoordinator.completionDelegate =  context.coordinator
        return prescriptionReviewUICoordinator
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
