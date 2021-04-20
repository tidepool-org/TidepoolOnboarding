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
    @Environment(\.dismiss) var dismiss

    @State private var isDestinationActive = false
    @State private var isCloseAlertPresented = false

    private let section: OnboardingSection
    private let editMode: Bool
    private let backButtonHidden: Bool
    private let nextButtonTitle: String?
    private let nextButtonAction: ((_ completion: @escaping (Bool) -> Void) -> Void)?
    private let destination: Destination?
    private let content: Content

    init(section: OnboardingSection, destination: Destination, @ViewBuilder content: () -> Content) {
        self.section = section
        self.editMode = false
        self.backButtonHidden = false
        self.nextButtonTitle = nil
        self.nextButtonAction = nil
        self.destination = destination
        self.content = content()
    }

    init(section: OnboardingSection, @ViewBuilder content: () -> Content) where Destination == EmptyView {
        self.section = section
        self.editMode = false
        self.backButtonHidden = false
        self.nextButtonTitle = nil
        self.nextButtonAction = nil
        self.destination = nil
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color(backgroundColor)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 10) {
                        Segment {
                            content
                        }
                        Spacer()
                        nextButton
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .navigationBarTitle(Text(onboardingViewModel.titleForSection(section)), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: closeButton)
        .navigationBarTranslucent(false)
        .navigationBarBackgroundColor(backgroundColor)
        .navigationBarShadowColor(.clear)
    }

    @ViewBuilder
    private var nextButton: some View {
        VStack {
            ActionButton(title: nextButtonTitleResolved, action: nextButtonActionResolved)
                .accessibilityIdentifier("button_next")
            if let destination = destination {
                NavigationLink(destination: destination, isActive: $isDestinationActive) { EmptyView() }
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
            isDestinationActive = true
        } else {
            complete()
        }
    }

    @ViewBuilder
    private var backButton: some View {
        if !backButtonHidden {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                    Text(backButtonTitle)
                        .fontWeight(.regular)
                }
                .offset(x: -6, y: 0)
            }
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(backButtonTitle)
            .accessibilityIdentifier("button_back")
        } else {
            EmptyView()
        }
    }

    private var backButtonTitle: String { LocalizedString("Back", comment: "Back navigation button title of an onboarding section page view") }

    private var closeButton: some View {
        Button(action: { isCloseAlertPresented = true }) {
            Text(closeButtonTitle)
                .fontWeight(.regular)
        }
        .alert(isPresented: $isCloseAlertPresented) { closeAlert }
        .accessibilityElement()
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(closeButtonTitle)
        .accessibilityIdentifier("button_close")
    }

    private var closeButtonTitle: String { LocalizedString("Close", comment: "Close navigation button title of an onboarding section page view") }

    private var closeAlert: Alert {
        Alert(title: Text(LocalizedString("Are you sure?", comment: "Alert title confirming close of an onboarding section page view")),
              message: Text(LocalizedString("You'll have to restart this section.", comment: "Alert message confirming close of an onboarding section page view")),
              primaryButton: .cancel(),
              secondaryButton: .destructive(Text(LocalizedString("End", comment: "Alert button confirming close of an onboarding section page view")), action: dismiss))
    }

    private var backgroundColor: UIColor { editMode ? .secondarySystemBackground : .systemBackground }
}

extension OnboardingSectionPageView {
    init(_ other: Self, editMode: Bool? = nil, backButtonHidden: Bool? = nil, nextButtonTitle: String? = nil, nextButtonAction: ((@escaping (Bool) -> Void) -> Void)? = nil) {
        self.section = other.section
        self.editMode = editMode ?? other.editMode
        self.backButtonHidden = backButtonHidden ?? other.backButtonHidden
        self.nextButtonTitle = nextButtonTitle ?? other.nextButtonTitle
        self.nextButtonAction = nextButtonAction ?? other.nextButtonAction
        self.destination = other.destination
        self.content = other.content
    }

    func editMode(_ editMode: Bool) -> Self { Self(self, editMode: editMode) }

    func backButtonHidden(_ backButtonHidden: Bool) -> Self { Self(self, backButtonHidden: backButtonHidden) }

    func nextButtonTitle(_ nextButtonTitle: String) -> Self { Self(self, nextButtonTitle: nextButtonTitle) }

    func nextButtonAction(_ nextButtonAction: @escaping (@escaping (Bool) -> Void) -> Void) -> Self { Self(self, nextButtonAction: nextButtonAction) }
}
