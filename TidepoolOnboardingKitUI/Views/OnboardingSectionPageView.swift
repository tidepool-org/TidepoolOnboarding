//
//  OnboardingSectionPageView.swift
//  TidepoolOnboardingKitUI
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

    @State private var isCloseAlertPresented = false

    private let section: OnboardingSection
    private let editMode: Bool
    private let backButtonHidden: Bool
    private let destination: Destination?
    private let content: Content

    init(section: OnboardingSection, editMode: Bool = false, backButtonHidden: Bool = false, destination: Destination, @ViewBuilder content: () -> Content) {
        self.section = section
        self.editMode = editMode
        self.backButtonHidden = backButtonHidden
        self.destination = destination
        self.content = content()
    }

    init(section: OnboardingSection, editMode: Bool = false, backButtonHidden: Bool = false, @ViewBuilder content: () -> Content) where Destination == EmptyView {
        self.section = section
        self.editMode = editMode
        self.backButtonHidden = backButtonHidden
        self.destination = nil
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color(editMode ? .secondarySystemBackground : .systemBackground)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 10) {
                        Segment {
                            content
                        }
                        Spacer()
                        continueButton
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .alert(isPresented: $isCloseAlertPresented) { closeAlert }
        .navigationBarTitle(Text(onboardingViewModel.titleForSection(section)), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: closeButton)
        .navigationBarTransparent(true)
    }

    @ViewBuilder
    private var continueButton: some View {
        if let destination = destination {
            NavigationButton(title: continueButtonTitle, destination: destination)
                .accessibilityIdentifier("button_continue")
        } else {
            ActionButton(title: continueButtonTitle, action: complete)
                .accessibilityIdentifier("button_continue")
        }
    }

    private var continueButtonTitle: String { LocalizedString("Continue", comment: "Continue button of an onboarding section page view") }

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

    private var backButtonTitle: String { LocalizedString("Back", comment: "Back navigation button of an onboarding section page view") }

    private var closeButton: some View {
        Button(action: { isCloseAlertPresented = true }) {
            Text(closeButtonTitle)
                .fontWeight(.regular)
        }
        .accessibilityElement()
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(closeButtonTitle)
        .accessibilityIdentifier("button_close")
    }

    private var closeButtonTitle: String { LocalizedString("Close", comment: "Close navigation button of an onboarding section page view") }

    private var closeAlert: Alert {
        Alert(title: Text(LocalizedString("Are you sure?", comment: "Alert title confirming close of an onboarding section page view")),
              message: Text(LocalizedString("You'll have to restart this section.", comment: "Alert message confirming close of an onboarding section page view")),
              primaryButton: .cancel {
                isCloseAlertPresented = false
              },
              secondaryButton: .destructive(Text(LocalizedString("End", comment: "Alert button confirming close of an onboarding section page view"))) {
                dismiss()
              })
    }
}
