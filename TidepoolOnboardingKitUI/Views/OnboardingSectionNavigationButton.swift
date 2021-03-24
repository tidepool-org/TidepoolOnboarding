//
//  OnboardingSectionNavigationButton.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct OnboardingSectionNavigationButton<Destination: View>: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    let section: OnboardingSection
    let destination: Destination

    var body: some View {
        switch onboardingViewModel.sectionProgression.stateForSection(section) {
        case .completed:
            content
                .accessibilityHidden(true)
        case .available:
            OnboardingSectionSheetButton(section: section, destination: destination) {
                content
            }
            .accessibilityLabel(accessibilityLabel)
        case .unavailable:
            content
                .opacity(0.5)
                .accessibilityHidden(true)
        }
    }

    private var content: some View {
        VStack(alignment: .leading) {
            HStack {
                titleText
                Spacer()
                selectionIndicator
                    .frame(width: 22, height: 22)
                    .foregroundColor(.accentColor)
                    .alertOnLongPressGesture(enabled: onboardingViewModel.allowSkipOnboarding && !onboardingViewModel.sectionProgression.hasCompletedSection(section),
                                             title: "Are you sure you want to skip through this section?") {  // Not localized
                        onboardingViewModel.skipThroughSection(section)   // NOTE: SKIP ONBOARDING - DEBUG AND TEST ONLY
                    }
            }
            Spacer()
            durationText
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
        .accessibilityElement(children: .ignore)
    }

    private var titleText: some View {
        Text(onboardingViewModel.titleForSection(section))
            .font(.headline)
            .accentColor(.primary)
    }

    private var durationText: some View {
        Text(onboardingViewModel.durationStringForSection(section))
            .font(.subheadline)
            .bold()
            .accentColor(.secondary)
    }

    @ViewBuilder
    private var selectionIndicator: some View {
        if onboardingViewModel.sectionProgression.hasCompletedSection(section) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
        } else {
            Circle()
                .stroke(lineWidth: 2)
        }
    }

    private var accessibilityLabel: String {
        return String(format: LocalizedString("%1@, %2@", comment: "Section navigation button accessibility label (1: title, 2: estimated duration)"),
                      onboardingViewModel.titleForSection(section),
                      onboardingViewModel.durationStringForSection(section))
    }
}

struct OnboardingSectionNavigationButton_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.howTheAppWorks)
        return onboardingViewModel
    }()

    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()

    static var previews: some View {
        return ContentPreviewWithBackground {
            VStack(alignment: .leading) {
                OnboardingSectionNavigationButton(section: .introduction, destination: CompleteDismissView())
                    .environmentObject(onboardingViewModel)
                    .environmentObject(displayGlucoseUnitObservable)
                OnboardingSectionNavigationButton(section: .howTheAppWorks, destination: CompleteDismissView())
                    .environmentObject(onboardingViewModel)
                    .environmentObject(displayGlucoseUnitObservable)
                OnboardingSectionNavigationButton(section: .aDayInTheLife, destination: CompleteDismissView())
                    .environmentObject(onboardingViewModel)
                    .environmentObject(displayGlucoseUnitObservable)
            }
        }
    }
}
