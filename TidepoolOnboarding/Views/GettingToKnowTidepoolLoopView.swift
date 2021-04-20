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

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    title
                    description
                        .padding(.bottom)
                    buttons
                }
                .padding()
            }
        }
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
        Text(LocalizedString("You can take your time through each section. The app will save your place and start you back at the beginning of a section if you step away.", comment: "Onboarding, Getting to Know Tidepool Loop summary, body"))
            .font(.body)
            .accentColor(.secondary)
            .foregroundColor(.accentColor)
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

    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()

    static var previews: some View {
        ContentPreview {
            GettingToKnowTidepoolLoopView()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
