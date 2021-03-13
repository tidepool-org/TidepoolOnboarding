//
//  PrescriptionReviewView.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI

struct PrescriptionReviewView: UIViewControllerRepresentable {
    @EnvironmentObject var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable
    @Environment(\.colorPalette) var colorPalette: LoopUIColorPalette
    @Environment(\.complete) var complete

    var hasNewTherapySettings: (TherapySettings) -> Void

    final class Coordinator: PrescriptionReviewDelegate, CompletionDelegate {
        private let parent: PrescriptionReviewView

        init(_ parent: PrescriptionReviewView) {
            self.parent = parent
        }

        func prescriptionReview(hasNewTherapySettings therapySettings: TherapySettings) {
            parent.hasNewTherapySettings(therapySettings)
        }

        func completionNotifyingDidComplete(_ object: CompletionNotifying) {
            guard let prescriptionReviewUICoordinator = object as? PrescriptionReviewUICoordinator else { return }
            prescriptionReviewUICoordinator.dismiss(animated: true)
            parent.complete()
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
