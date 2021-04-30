//
//  YourSettingsViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct YourSettingsNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .yourSettings, destination: NavigationViewWithNavigationBarAppearance { YourSettingsRootView() })
            .accessibilityIdentifier("button_your_settings")
    }
}

fileprivate struct YourSettingsRootView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        if onboardingViewModel.tidepoolService?.isOnboarded != true {
            TidepoolServiceOnboardingView()
        } else {
            PrescriptionReviewView()
        }
    }
}

// TODO: Placeholder - to be replaced with final view once delivered by product and design
fileprivate struct TidepoolServiceOnboardingView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var alertMessage: String?
    @State private var isAlertPresented = false

    @State private var sheetViewController: ServiceViewController?
    @State private var isSheetPresented = false
    @State private var onSheetDismiss: (() -> Void)?

    var body: some View {
        OnboardingSectionPageView(section: .yourSettings, destination: PrescriptionReviewView()) {
            PageHeader(title: LocalizedString("Your Tidepool Account", comment: "Onboarding, Your Settings section, view 1, title"))
            Paragraph(LocalizedString("If you already have a Tidepool acccount you can Sign In.", comment: "Onboarding, Your Settings section, view 1, paragraph"))
        }
        .backButtonHidden(true)
        .nextButtonTitle(LocalizedString("Sign In", comment: "Onboarding, Your Settings section, view 1, sign up button, title"))
        .nextButtonAction(nextButtonAction)
        .alert(isPresented: $isAlertPresented) { alert }
        .sheet(isPresented: $isSheetPresented, onDismiss: onSheetDismiss) { sheet }
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        switch onboardingViewModel.onboardTidepoolService() {
        case .failure(let error):
            self.alertMessage = error.localizedDescription
            self.isAlertPresented = true
        case .success(let success):
            switch success {
            case .userInteractionRequired(let viewController):
                self.sheetViewController = viewController
                self.isSheetPresented = true
                self.onSheetDismiss = { completion(onboardingViewModel.tidepoolService?.isOnboarded == true) }
            case .createdAndOnboarded:
                completion(onboardingViewModel.tidepoolService?.isOnboarded == true)
            }
        }
    }

    private var alert: Alert {
        Alert(title: Text(LocalizedString("Error", comment: "Title of general error alert")), message: Text(alertMessage!))
    }

    private var sheet: some View {
        TidepoolServiceView(sheetViewController!)
            .presentation(isModal: true)
            .environment(\.dismiss, { isSheetPresented = false })
    }
}

fileprivate struct TidepoolServiceView: UIViewControllerRepresentable {
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
