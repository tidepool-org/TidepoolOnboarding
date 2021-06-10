//
//  CGMManagerView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/10/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct CGMManagerView: UIViewControllerRepresentable {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.dismissAction) var dismiss

    private let cgmManagerViewController: CGMManagerViewController

    init(_ cgmManagerViewController: CGMManagerViewController) {
        self.cgmManagerViewController = cgmManagerViewController
    }

    final class Coordinator: CompletionDelegate {
        private let parent: CGMManagerView

        init(_ parent: CGMManagerView) {
            self.parent = parent
        }

        func completionNotifyingDidComplete(_ object: CompletionNotifying) {
            parent.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        var cgmManagerViewController = self.cgmManagerViewController
        cgmManagerViewController.cgmManagerOnboardingDelegate = onboardingViewModel
        cgmManagerViewController.completionDelegate = context.coordinator
        return cgmManagerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
