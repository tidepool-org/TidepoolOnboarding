//
//  PumpManagerView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/10/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct PumpManagerView: UIViewControllerRepresentable {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss

    private let pumpManagerViewController: PumpManagerViewController

    init(_ pumpManagerViewController: PumpManagerViewController) {
        self.pumpManagerViewController = pumpManagerViewController
    }

    final class Coordinator: CompletionDelegate {
        private let parent: PumpManagerView

        init(_ parent: PumpManagerView) {
            self.parent = parent
        }

        func completionNotifyingDidComplete(_ object: CompletionNotifying) {
            parent.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        var pumpManagerViewController = self.pumpManagerViewController
        pumpManagerViewController.pumpManagerOnboardingDelegate = onboardingViewModel
        pumpManagerViewController.completionDelegate = context.coordinator
        return pumpManagerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
