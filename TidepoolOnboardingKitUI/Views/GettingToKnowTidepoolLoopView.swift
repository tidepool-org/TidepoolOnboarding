//
//  GettingToKnowTidepoolLoopView.swift
//  TidepoolOnboardingKitUI
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
        Text(LocalizedString("Getting to Know Tidepool Loop", comment: "Title of Getting to Know Tidepool Loop view"))
            .font(.largeTitle)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityAddTraits(.isHeader)
            .abortOnLongPressGesture(enabled: onboardingViewModel.allowSkipOnboarding) {
                onboardingViewModel.skipOnboarding()   // NOTE: SKIP ONBOARDING - DEBUG AND TEST ONLY
            }
    }

    private var description: some View {
        Text(LocalizedString("You can take your time through each section. The app will save your place and start you back at the beginning of a section if you step away.", comment: "Description on Getting to Know Tidepool Loop view"))
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
    static var previews: some View {
        ContentPreview {
            GettingToKnowTidepoolLoopView()
                .environmentObject(OnboardingViewModel.preview)
                .environmentObject(DisplayGlucoseUnitObservable.preview)
        }
    }
}
