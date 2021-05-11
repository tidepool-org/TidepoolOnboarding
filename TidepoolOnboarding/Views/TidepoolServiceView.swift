//
//  TidepoolServiceView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/5/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct TidepoolServiceView: UIViewControllerRepresentable {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss

    private let serviceViewController: ServiceViewController

    init(_ serviceViewController: ServiceViewController) {
        self.serviceViewController = serviceViewController
    }

    final class Coordinator: CompletionDelegate {
        private let parent: TidepoolServiceView

        init(_ parent: TidepoolServiceView) {
            self.parent = parent
        }

        func completionNotifyingDidComplete(_ object: CompletionNotifying) {
            parent.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        var serviceViewController = self.serviceViewController
        serviceViewController.serviceOnboardingDelegate = onboardingViewModel
        serviceViewController.completionDelegate = context.coordinator
        return serviceViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
