//
//  OnboardingSectionPageView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct OnboardingSectionPageView<Destination: View, Content: View>: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.complete) var complete

    @State private var isDestinationActiveFromNextButton = false
    @State private var isCloseAlertPresented = false

    private let section: OnboardingSection
    private let editMode: Bool
    private let backButtonHidden: Bool
    private let closeButtonHidden: Bool
    private let nextButtonHidden: Bool
    private let nextButtonTitle: String?
    private let nextButtonAction: ((_ completion: @escaping (Bool) -> Void) -> Void)?
    private let nextButtonDisabled: Bool
    private let destination: Destination?
    private let isDestinationActive: Binding<Bool>
    private let content: Content

    init(section: OnboardingSection, destination: Destination, isDestinationActive: Binding<Bool> = .constant(false), @ViewBuilder content: () -> Content) {
        self.section = section
        self.editMode = false
        self.backButtonHidden = false
        self.closeButtonHidden = false
        self.nextButtonHidden = false
        self.nextButtonTitle = nil
        self.nextButtonAction = nil
        self.nextButtonDisabled = false
        self.destination = destination
        self.isDestinationActive = isDestinationActive
        self.content = content()
    }

    init(section: OnboardingSection, @ViewBuilder content: () -> Content) where Destination == EmptyView {
        self.section = section
        self.editMode = false
        self.backButtonHidden = false
        self.closeButtonHidden = false
        self.nextButtonHidden = false
        self.nextButtonTitle = nil
        self.nextButtonAction = nil
        self.nextButtonDisabled = false
        self.destination = nil
        self.isDestinationActive = .constant(false)
        self.content = content()
    }

    var body: some View {
        OnboardingSectionWrapperView(section: section) {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 10) {
                        Segment {
                            content
                        }
                        Spacer()
                        if !nextButtonHidden {
                            nextButton
                        }
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .editMode(editMode)
        .backButtonHidden(backButtonHidden)
        .closeButtonHidden(closeButtonHidden)
    }

    @ViewBuilder
    private var nextButton: some View {
        VStack {
            ActionButton(title: nextButtonTitleResolved, action: nextButtonActionResolved)
                .disabled(nextButtonDisabled)
                .accessibilityIdentifier("button_next")
            if let destination = destination {
                NavigationLink(destination: destination, isActive: isDestinationActiveResolved) { EmptyView() }
            }
        }
    }

    private var nextButtonTitleResolved: String {
        return nextButtonTitle ?? LocalizedString("Continue", comment: "Default next button title of an onboarding section page view")
    }

    private func nextButtonActionResolved() {
        if let nextButtonAction = nextButtonAction {
            nextButtonAction { success in
                if success {
                    nextButtonActionComplete()
                }
            }
        } else {
            nextButtonActionComplete()
        }
    }

    private func nextButtonActionComplete() {
        if destination != nil {
            isDestinationActiveFromNextButton = true
        } else {
            complete()
        }
    }

    private var isDestinationActiveResolved: Binding<Bool> {
        Binding(
            get: { isDestinationActive.wrappedValue || isDestinationActiveFromNextButton },
            set: {
                isDestinationActive.wrappedValue = $0
                isDestinationActiveFromNextButton = $0
            }
        )
    }
}

extension OnboardingSectionPageView {
    init(_ other: Self, editMode: Bool? = nil, backButtonHidden: Bool? = nil, closeButtonHidden: Bool? = nil, nextButtonHidden: Bool? = nil, nextButtonTitle: String? = nil, nextButtonAction: ((@escaping (Bool) -> Void) -> Void)? = nil, nextButtonDisabled: Bool? = nil) {
        self.section = other.section
        self.editMode = editMode ?? other.editMode
        self.backButtonHidden = backButtonHidden ?? other.backButtonHidden
        self.closeButtonHidden = closeButtonHidden ?? other.closeButtonHidden
        self.nextButtonHidden = nextButtonHidden ?? other.nextButtonHidden
        self.nextButtonTitle = nextButtonTitle ?? other.nextButtonTitle
        self.nextButtonAction = nextButtonAction ?? other.nextButtonAction
        self.nextButtonDisabled = nextButtonDisabled ?? other.nextButtonDisabled
        self.destination = other.destination
        self.isDestinationActive = other.isDestinationActive
        self.content = other.content
    }

    func editMode(_ editMode: Bool?) -> Self { Self(self, editMode: editMode) }

    func backButtonHidden(_ backButtonHidden: Bool?) -> Self { Self(self, backButtonHidden: backButtonHidden) }

    func closeButtonHidden(_ closeButtonHidden: Bool?) -> Self { Self(self, closeButtonHidden: closeButtonHidden) }

    func nextButtonHidden(_ nextButtonHidden: Bool?) -> Self { Self(self, nextButtonHidden: nextButtonHidden) }

    func nextButtonTitle(_ nextButtonTitle: String?) -> Self { Self(self, nextButtonTitle: nextButtonTitle) }

    func nextButtonAction(_ nextButtonAction: ((@escaping (Bool) -> Void) -> Void)?) -> Self { Self(self, nextButtonAction: nextButtonAction) }

    func nextButtonDisabled(_ nextButtonDisabled: Bool?) -> Self { Self(self, nextButtonDisabled: nextButtonDisabled) }
}
