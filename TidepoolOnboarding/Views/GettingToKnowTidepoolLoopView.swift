//
//  GettingToKnowTidepoolLoopView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct GettingToKnowTidepoolLoopView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isCloseAlertPresented = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    if onboardingViewModel.isCGMManagerOnboarded {
                        closeButton
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        title
                        description
                            .padding(.bottom)
                        buttons
                    }
                }
                .padding()
            }
        }
    }

    private var closeButton: some View {
        HStack {
            Spacer()
            Button(action: { isCloseAlertPresented = true }) {
                Text(closeButtonTitle)
            }
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(closeButtonTitle)
            .accessibilityIdentifier("button_close")
        }
        .alert(isPresented: $isCloseAlertPresented) { closeAlert }
    }

    private var closeButtonTitle: String { LocalizedString("Close", comment: "Onboarding, Getting to Know Tidepool Loop summary, close button, title") }

    private var closeAlert: Alert {
        Alert(title: Text(LocalizedString("Are you sure?", comment: "Onboarding, Getting to Know Tidepool Loop summary, close alert, title")),
              message: Text(LocalizedString("You'll have to resume onboarding later.", comment: "Onboarding, Getting to Know Tidepool Loop summary, close alert, message")),
              primaryButton: .cancel(),
              secondaryButton: .destructive(Text(LocalizedString("Pause", comment: "Onboarding, Getting to Know Tidepool Loop summary, close alert, pause button")),
                                            action: { onboardingViewModel.isSuspended = true }))
    }

    private var title: some View {
        Text(LocalizedString("Getting to Know Tidepool Loop", comment: "Onboarding, Getting to Know Tidepool Loop summary, title"))
            .font(.largeTitle)
            .bold()
            .accessibilityAddTraits(.isHeader)
            .alertOnLongPressGesture(enabled: onboardingViewModel.allowDebugFeatures,
                                     title: "Are you sure you want to skip the rest of onboarding?") {  // Not localized
                onboardingViewModel.skipAllSections()   // NOTE: DEBUG FEATURES - DEBUG AND TEST ONLY
            }
    }

    private var description: some View {
        BodyText(LocalizedString("You can take your time through each section. The app will save your place and start you back at the beginning of a section if you step away.", comment: "Onboarding, Getting to Know Tidepool Loop summary, body"))
    }

    private var buttons: some View {
        VStack(spacing: 10) {
            IntroductionNavigationButton()
            HowTheAppWorksNavigationButton()
            ADayInTheLifeNavigationButton()
            YourSettingsNavigationButton()
            YourDevicesNavigationButton()
            GetLoopingNavigationButton()
        }
    }
}

struct GettingToKnowTidepoolLoopView_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.introduction)
        return onboardingViewModel
    }()

    static var displayGlucosePreference: DisplayGlucosePreference = {
        return DisplayGlucosePreference.preview
    }()

    static var previews: some View {
        ContentPreview {
            GettingToKnowTidepoolLoopView()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucosePreference)
        }
    }
}
