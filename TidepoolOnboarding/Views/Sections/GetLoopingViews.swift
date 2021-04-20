//
//  GetLoopingViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct GetLoopingNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .getLooping, destination: NavigationViewWithNavigationBarAppearance { GetLoopingView1() })
            .accessibilityIdentifier("button_get_looping")
    }
}

fileprivate struct GetLoopingView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .getLooping, destination: GetLoopingView2()) {
            PageHeader(title: LocalizedString("Closed Loop Mode", comment: "Onboarding, Get Looping section, view 1, title"), page: 1, of: 3)
            PresentableImage(decorative: "GetLooping_1")
            Paragraph(LocalizedString("There are two modes of operation for Tidepool Loop:", comment: "Onboarding, Get Looping section, view 1, paragraph"))
                .fixedSize(horizontal: false, vertical: true)
            BulletedBodyTextList(
                LocalizedString("Closed Loop ON", comment: "Onboarding, Get Looping section, view 1, list, item 1"),
                LocalizedString("Closed Loop OFF", comment: "Onboarding, Get Looping section, view 1, list, item 2")
            )
            segment1
            segment2
        }
        .backButtonHidden(true)
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Closed Loop ON", comment: "Onboarding, Get Looping section, view 1, segment 1, header")) {
            Paragraph(LocalizedString("When the Closed Loop switch is in the ON position, Tidepool Loop will actively adjust your insulin dosing in response to your glucose as often as every 5 minutes.", comment: "Onboarding, Get Looping section, view 1, segment 1, paragraph"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Closed Loop OFF", comment: "Onboarding, Get Looping section, view 1, segment 2, header")) {
            Paragraph(LocalizedString("When the Closed Loop switch is in the OFF position, the app will NOT automatically adjust your basal insulin.", comment: "Onboarding, Get Looping section, view 1, segment 2, paragraph 1"))
            Paragraph(LocalizedString("You may use this Closed Loop OFF mode:", comment: "Onboarding, Get Looping section, view 1, segment 2, paragraph 2"))
            BulletedBodyTextList(
                LocalizedString("When you don’t have an active sensor session", comment: "Onboarding, Get Looping section, view 1, segment 2, list, item 1"),
                LocalizedString("In circumstances where you may want to take full manual control of your insulin dosing decisions", comment: "Onboarding, Get Looping section, view 1, segment 2, list, item 2")
            )
            Callout(title: LocalizedString("Note: Some features unavailable", comment: "Onboarding, Get Looping section, view 1, segment 2, callout, title")) {
                Paragraph(LocalizedString("Please note that some features of the app may work differently or be unavailable when Closed Loop is OFF. See your User Guide for more details.", comment: "Onboarding, Get Looping section, view 1, segment 2, callout, paragraph"))
            }
        }
    }
}

fileprivate struct GetLoopingView2: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    @State private var isOffAlertPresented = false
    
    var body: some View {
        OnboardingSectionPageView(section: .getLooping, destination: GetLoopingView3()) {
            PageHeader(title: LocalizedString("Select Loop Mode", comment: "Onboarding, Get Looping section, view 2, title"), page: 2, of: 3)
            if onboardingViewModel.dosingEnabled {
                Paragraph(LocalizedString("Closed Loop is now set to ON.", comment: "Onboarding, Get Looping section, view 2, paragraph 1, closed loop on"))
            } else {
                Paragraph(LocalizedString("Closed Loop is now set to OFF.", comment: "Onboarding, Get Looping section, view 2, paragraph 1, closed loop off"))
            }
            Paragraph(LocalizedString("You can toggle it on and off now or later in Settings.", comment: "Onboarding, Get Looping section, view 2, paragraph 2"))
            HStack(spacing: 10) {
                toggle
            }
            .background(editableBackground)
        }
        .editMode(true)
        .alert(isPresented: $isOffAlertPresented) { offAlert }
    }

    private var toggle: some View {
        Toggle(LocalizedString("Closed Loop", comment: "Onboarding, Get Looping section, view 2, closed loop"), isOn: isClosedLoopOn)
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .padding(.horizontal)
            .padding(.vertical, 7)
    }
    
    private var isClosedLoopOn: Binding<Bool> {
        Binding(
            get: { onboardingViewModel.dosingEnabled },
            set: {
                onboardingViewModel.dosingEnabled = $0
                if !onboardingViewModel.dosingEnabled {
                    isOffAlertPresented = true
                }
            }
        )
    }
    
    private var offAlert: Alert {
        Alert(title: Text(LocalizedString("Are you sure?", comment: "Onboarding, Get Looping section, view 2, off alert, title")),
              message: Text(LocalizedString("By setting Closed Loop to OFF, automation of insulin delivery will not begin until you toggle it ON later in Settings.", comment: "Onboarding, Get Looping section, view 2, off alert, message")),
              primaryButton: .cancel { onboardingViewModel.dosingEnabled = true },
              secondaryButton: .default(Text(LocalizedString("Continue", comment: "Onboarding, Get Looping section, view 2, off alert, continue button"))))
    }
    
    private var editableBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color(.tertiarySystemBackground))
    }
}

fileprivate struct GetLoopingView3: View {
    var body: some View {
        OnboardingSectionPageView(section: .getLooping) {
            PageHeader(title: LocalizedString("You’re Ready", comment: "Onboarding, Get Looping section, view 3, title"), page: 3, of: 3)
            PresentableImage(decorative: "GetLooping_3")
            Paragraph(LocalizedString("If you need help, you can find help in Settings to:", comment: "Onboarding, Get Looping section, view 3, paragraph 1"))
                .fixedSize(horizontal: false, vertical: true)
            BulletedBodyTextList(
                LocalizedString("Consult your Tidepool Loop User Guide", comment: "Onboarding, Get Looping section, view 3, list, item 1"),
                LocalizedString("Visit our knowledge base of Support articles", comment: "Onboarding, Get Looping section, view 3, list, item 2"),
                LocalizedString("Reach out to the Tidepool Support team", comment: "Onboarding, Get Looping section, view 3, list, item 3")
            )
            Paragraph(LocalizedString("We’re here for you!", comment: "Onboarding, Get Looping section, view 3, paragraph 2"))
        }
        .nextButtonTitle(LocalizedString("Start Tidepool Loop", comment: "Onboarding, Get Looping section, view 3, next button, title"))
    }
}

struct GetLoopingViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.getLooping)
        return onboardingViewModel
    }()
    
    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()
    
    static var previews: some View {
        ContentPreviewWithBackground {
            GetLoopingNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
