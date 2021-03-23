//
//  ModalPresentation.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/17/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

extension View {
    func presentation(isModal: Bool, onDismissalAttempt: (() -> Void)? = nil) -> some View {
        ModalPresentationView(view: self, isModal: isModal, onDismissalAttempt: onDismissalAttempt)
    }
}

fileprivate struct ModalPresentationView<T: View>: UIViewControllerRepresentable {
    let view: T
    let isModal: Bool
    let onDismissalAttempt: (() -> Void)?

    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        private let parent: ModalPresentationView

        init(_ parent: ModalPresentationView) {
            self.parent = parent
        }

        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool { !parent.isModal }

        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            parent.onDismissalAttempt?()
        }
    }

    func makeUIViewController(context: Context) -> UIHostingController<T> { UIHostingController(rootView: view) }

    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        uiViewController.rootView = view
        uiViewController.parent?.presentationController?.delegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
