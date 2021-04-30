//
//  IntroductionViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct IntroductionNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .introduction, destination: NavigationViewWithNavigationBarAppearance { IntroductionView1() })
            .accessibilityIdentifier("button_introduction")
    }
}

fileprivate struct IntroductionView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, destination: IntroductionView2()) {
            PageHeader(title: LocalizedString("The Parts of Tidepool Loop", comment: "Onboarding, Introduction section, view 1, title"))
            Graphic()
                .accessibilityHidden(true)
            Paragraph(LocalizedString("The Tidepool Loop app connects and controls all of the pieces of your system.", comment: "Onboarding, Introduction section, view 1, paragraph 1"))
            Paragraph(LocalizedString("You may already be familiar with each of these devices, but here is a brief overview.", comment: "Onboarding, Introduction section, view 1, paragraph 2"))
        }
        .backButtonHidden(true)
    }
    
    private struct Graphic: View {
        @ScaledMetric private var paddingLeading: CGFloat = 10
        @ScaledMetric private var paddingTop: CGFloat = 10
        @ScaledMetric private var paddingTrailing: CGFloat = 10
        @ScaledMetric private var paddingBottom: CGFloat = 30
        
        var body: some View {
            VStack {
                CalloutText(LocalizedString("Mobile Device", comment: "Onboarding, Introduction section, view 1, graphic, mobile device label"))
                    .multilineTextAlignment(.center)
                CalloutText(LocalizedString("(Apple Watch Optional)", comment: "Onboarding, Introduction section, view 1, graphic, Apple Watch optional label"))
                    .multilineTextAlignment(.center)
                PresentableImage(decorative: "Introduction_1")
                    .overlay(overlay)
            }
            .padding(.leading, paddingLeading)
            .padding(.top, paddingTop)
            .padding(.trailing, paddingTrailing)
            .padding(.bottom, paddingBottom)
        }
        
        private var overlay: some View {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Color.clear
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    CalloutText(LocalizedString("CGM", comment: "Onboarding, Introduction section, view 1, graphic, CGM label"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: geometry.size.width * 0.50)
                        .alignmentGuide(VerticalAlignment.top, computeValue: { _ in -geometry.size.height * 0.950 })
                        .offset(x: -geometry.size.width * 0.368, y: 0)
                    CalloutText(LocalizedString("Insulin Pump", comment: "Onboarding, Introduction section, view 1, graphic, insulin pump label"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: geometry.size.width * 0.50)
                        .alignmentGuide(VerticalAlignment.top, computeValue: { _ in -geometry.size.height * 0.950 })
                        .offset(x: geometry.size.width * 0.368, y: 0)
                }
            }
        }
    }
}

fileprivate struct IntroductionView2: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, destination: IntroductionView3()) {
            PageHeader(title: LocalizedString("CGM", comment: "Onboarding, Introduction section, view 2, title"))
            PresentableImage(decorative: "Introduction_2")
            Paragraph(LocalizedString("A continuous glucose monitor (CGM) is made up of a small sensor attached to a transmitter.", comment: "Onboarding, Introduction section, view 2, paragraph 1"))
            Paragraph(LocalizedString("The sensor measures glucose levels just under the skin, and the transmitter sends the data wirelessly to the Tidepool Loop app via Bluetooth.", comment: "Onboarding, Introduction section, view 2, paragraph 2"))
            Paragraph(LocalizedString("Sensor glucose data is available for:", comment: "Onboarding, Introduction section, view 2, paragraph 3"))
            BulletedBodyTextList(
                LocalizedString("Viewing in the app", comment: "Onboarding, Introduction section, view 2, list, item 1"),
                LocalizedString("Automating your insulin dosing", comment: "Onboarding, Introduction section, view 2, list, item 2"),
                LocalizedString("Alerting you to changes in your glucose", comment: "Onboarding, Introduction section, view 2, list, item 3")
            )
        }
    }
}

fileprivate struct IntroductionView3: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, destination: IntroductionView4()) {
            PageHeader(title: LocalizedString("Insulin Pump", comment: "Onboarding, Introduction section, view 3, title"))
            PresentableImage(decorative: "Introduction_3")
            Paragraph(LocalizedString("An insulin pump continuously delivers U-100 rapid-acting insulin under the skin to cover your background insulin needs.", comment: "Onboarding, Introduction section, view 3, paragraph 1"))
            Paragraph(LocalizedString("This background insulin is called basal insulin.", comment: "Onboarding, Introduction section, view 3, paragraph 2"))
            Paragraph(LocalizedString("The pump is also used to deliver a bolus of rapid-acting insulin to cover carbs or bring down high glucose into your Correction Range.", comment: "Onboarding, Introduction section, view 3, paragraph 3"))
        }
    }
}

fileprivate struct IntroductionView4: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, destination: IntroductionView5()) {
            PageHeader(title: LocalizedString("Tidepool Loop App", comment: "Onboarding, Introduction section, view 4, title"))
            PresentableImage(decorative: "Introduction_4_1")
            Paragraph(LocalizedString("The Tidepool Loop app receives glucose and insulin information from your diabetes devices and sends commands back to the pump to adjust your insulin delivery.", comment: "Onboarding, Introduction section, view 4, paragraph"))
            segment1
            segment2
            segment3
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Tidepool Loop’s Connection", comment: "Onboarding, Introduction section, view 4, segment 1, header")) {
            PresentableImage(decorative: "Introduction_4_2")
            Paragraph(LocalizedString("The app connects directly to your devices via a Bluetooth connection and does not require internet for automation.", comment: "Onboarding, Introduction section, view 4, segment 1, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop automates insulin dosing with or without an internet connection.", comment: "Onboarding, Introduction section, view 4, segment 1, paragraph 2"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Bluetooth Communication", comment: "Onboarding, Introduction section, view 4, segment 2, header")) {
            Paragraph(LocalizedString("Your iPhone or iPod Touch must be on and within Bluetooth range of your pump in order for the app to send commands to the pump.", comment: "Onboarding, Introduction section, view 4, psegment 2, paragraph"))
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Interacting with the App", comment: "Onboarding, Introduction section, view 4, segment 3, header")) {
            Paragraph(LocalizedString("You will interact with the Tidepool Loop app to:", comment: "Onboarding, Introduction section, view 4, segment 3, paragraph"))
            BulletedBodyTextList(
                LocalizedString("Enter your personal diabetes settings", comment: "Onboarding, Introduction section, view 4, segment 3, list, item 1"),
                LocalizedString("Deliver bolus insulin for food and to bring down high glucose", comment: "Onboarding, Introduction section, view 4, segment 3, list, item 2"),
                LocalizedString("Make temporary glucose range adjustments", comment: "Onboarding, Introduction section, view 4, segment 3, list, item 3"),
                LocalizedString("View glucose history and insulin delivery history", comment: "Onboarding, Introduction section, view 4, segment 3, list, item 4"),
                LocalizedString("Maintain your devices", comment: "Onboarding, Introduction section, view 4, segment 3, list, item 5"),
                LocalizedString("Troubleshoot and get support from Tidepool", comment: "Onboarding, Introduction section, view 4, segment 3, list, item 6")
            )
        }
    }
}

fileprivate struct IntroductionView5: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, destination: IntroductionView6()) {
            PageHeader(title: LocalizedString("Apple Watch (Optional)", comment: "Onboarding, Introduction section, view 5, title"))
            PresentableImage(decorative: "Introduction_5_1")
            Paragraph(LocalizedString("You can choose to use an Apple Watch with Tidepool Loop.", comment: "Onboarding, Introduction section, view 5, paragraph 1"))
            Paragraph(LocalizedString("This optional component allows you a discreet way to view your sensor glucose and insulin information, enter carbs, and deliver a bolus.", comment: "Onboarding, Introduction section, view 5, paragraph 2"))
            PresentableImage(decorative: "Introduction_5_2")
            Paragraph(LocalizedString("Apple Watch sends commands through your iPhone. Your watch must be on and within Bluetooth range of your iPhone, and your iPhone must be in Bluetooth range of your pump, in order for the watch to send commands to the pump.", comment: "Onboarding, Introduction section, view 5, paragraph 3"))
            Paragraph(LocalizedString("The Apple Watch cannot be used to send commands to your devices when out of range of your iPhone.", comment: "Onboarding, Introduction section, view 5, paragraph 4"))
        }
    }
}

fileprivate struct IntroductionView6: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, destination: IntroductionView7()) {
            PageHeader(title: LocalizedString("How Automation Works", comment: "Onboarding, Introduction section, view 5, title"))
            PresentableImage(decorative: "Introduction_6_1")
            Paragraph(LocalizedString("The Tidepool Loop app makes a prediction about your future glucose by looking at:", comment: "Onboarding, Introduction section, view 5, paragraph 1"))
            BulletedBodyTextList(
                LocalizedString("Your settings", comment: "Onboarding, Introduction section, view 5, list, item 1"),
                LocalizedString("Your sensor glucose", comment: "Onboarding, Introduction section, view 5, list, item 2"),
                LocalizedString("Your recent insulin delivery", comment: "Onboarding, Introduction section, view 5, list, item 3"),
                LocalizedString("Your recent entries about the carbs you’ve eaten", comment: "Onboarding, Introduction section, view 5, list, item 4")
            )
            Paragraph(LocalizedString("When automation is on, Tidepool Loop will adjust your basal insulin in an effort to reach your target glucose and reduce highs and lows.", comment: "Onboarding, Introduction section, view 5, paragraph 2"))
            Paragraph(LocalizedString("Tidepool Loop makes a calculation as often as every 5 minutes. This 5 minute cycle is called a “loop.”", comment: "Onboarding, Introduction section, view 5, paragraph 3"))
            PresentableImage(decorative: "Introduction_6_2")
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("See what’s going on", comment: "Onboarding, Introduction section, view 5, segment, header")) {
            Paragraph(LocalizedString("The app shows you how it’s working through the icons and charts on the home screen to help you decide if you need to take action.", comment: "Onboarding, Introduction section, view 5, segment, paragraph 1"))
            Paragraph(LocalizedString("You can see what’s happening at a glance or tap through each icon or chart for more details.", comment: "Onboarding, Introduction section, view 5, segment, paragraph 2"))
        }
    }
}

fileprivate struct IntroductionView7: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction) {
            PageHeader(title: LocalizedString("Checkpoint", comment: "Onboarding, Introduction section, view 7, title"))
            CheckpointCheckmark()
            Paragraph(LocalizedString("You’re now familiar with all the parts of Tidepool Loop! You’ve learned about:", comment: "Onboarding, Introduction section, view 7, paragraph 1"))
            CheckmarkedBodyTextList(
                LocalizedString("CGM", comment: "Onboarding, Introduction section, view 7, list, item 1"),
                LocalizedString("Sensor", comment: "Onboarding, Introduction section, view 7, list, item 2"),
                LocalizedString("Transmitter", comment: "Onboarding, Introduction section, view 7, list, item 3"),
                LocalizedString("Insulin Pump", comment: "Onboarding, Introduction section, view 7, list, item 4"),
                LocalizedString("Basal Insulin", comment: "Onboarding, Introduction section, view 7, list, item 5"),
                LocalizedString("Bolus Insulin", comment: "Onboarding, Introduction section, view 7, list, item 6"),
                LocalizedString("Tidepool Loop App", comment: "Onboarding, Introduction section, view 7, list, item 7"),
                LocalizedString("Apple Watch", comment: "Onboarding, Introduction section, view 7, list, item 8"),
                LocalizedString("Automation", comment: "Onboarding, Introduction section, view 7, list, item 9")
            )
            Paragraph(LocalizedString("If there is a concept you’d like to review, consult the Tidepool Loop User Guide for more details.", comment: "Onboarding, Introduction section, view 7, paragraph 2"))
        }
    }
}

struct IntroductionViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.introduction)
        return onboardingViewModel
    }()
    
    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()
    
    static var previews: some View {
        ContentPreviewWithBackground {
            IntroductionNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
