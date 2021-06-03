//
//  OnboardingSectionWrapperView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/5/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct OnboardingSectionWrapperView<Content: View>: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss

    private let section: OnboardingSection
    private let editMode: Bool
    private let backButtonHidden: Bool
    private let closeButtonHidden: Bool
    private let homeBarBackgroundColor: UIColor?
    private let content: Content

    @State private var isCloseAlertPresented = false

    init(section: OnboardingSection, @ViewBuilder content: () -> Content) {
        self.section = section
        self.editMode = false
        self.backButtonHidden = false
        self.closeButtonHidden = false
        self.homeBarBackgroundColor = nil
        self.content = content()
    }

    var body: some View {
        if backButtonHidden && closeButtonHidden {
            navigationView
        } else if backButtonHidden {
            navigationView.navigationBarItems(trailing: closeButton)
        } else if closeButtonHidden {
            navigationView.navigationBarItems(leading: backButton)
        } else {
            navigationView.navigationBarItems(leading: backButton, trailing: closeButton)
        }
    }

    private var navigationView: some View {
        ZStack {
            Color(backgroundColor)
                .edgesIgnoringSafeArea(.all)
            content
        }
        .navigationBarTitle(Text(onboardingViewModel.titleForSection(section)), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTranslucent(false)
        .navigationBarBackgroundColor(backgroundColor)
        .navigationBarShadowColor(.clear)
        .homeBarBackgroundColor(homeBarBackgroundColor ?? backgroundColor)
    }

    private var backButton: some View {
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
    }

    private var backButtonTitle: String { LocalizedString("Back", comment: "Back navigation button title of an onboarding section wrapper view") }

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

    private var closeButtonTitle: String { LocalizedString("Close", comment: "Close navigation button title of an onboarding section wrapper view") }

    private var closeAlert: Alert {
        Alert(title: Text(LocalizedString("Are you sure?", comment: "Alert title confirming close of an onboarding section wrapper view")),
              message: Text(LocalizedString("You'll have to restart this section.", comment: "Alert message confirming close of an onboarding section wrapper view")),
              primaryButton: .cancel(),
              secondaryButton: .destructive(Text(LocalizedString("End", comment: "Alert button confirming close of an onboarding section wrapper view")), action: dismiss))
    }

    private var backgroundColor: UIColor { editMode ? .systemGroupedBackground : .systemBackground }
}

extension OnboardingSectionWrapperView {
    init(_ other: Self, editMode: Bool? = nil, backButtonHidden: Bool? = nil, closeButtonHidden: Bool? = nil, homeBarBackgroundColor: UIColor? = nil) {
        self.section = other.section
        self.editMode = editMode ?? other.editMode
        self.backButtonHidden = backButtonHidden ?? other.backButtonHidden
        self.closeButtonHidden = closeButtonHidden ?? other.closeButtonHidden
        self.homeBarBackgroundColor = homeBarBackgroundColor ?? other.homeBarBackgroundColor
        self.content = other.content
    }

    func editMode(_ editMode: Bool?) -> Self { Self(self, editMode: editMode) }

    func backButtonHidden(_ backButtonHidden: Bool?) -> Self { Self(self, backButtonHidden: backButtonHidden) }

    func closeButtonHidden(_ closeButtonHidden: Bool?) -> Self { Self(self, closeButtonHidden: closeButtonHidden) }

    func homeBarBackgroundColor(_ homeBarBackgroundColor: UIColor?) -> Self { Self(self, homeBarBackgroundColor: homeBarBackgroundColor) }
}
