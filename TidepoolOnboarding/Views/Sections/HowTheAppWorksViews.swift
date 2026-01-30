//
//  HowTheAppWorksViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import LoopAlgorithm
import LoopKit
import LoopKitUI
import SwiftUI

struct HowTheAppWorksNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .howTheAppWorks, destination: NavigationView { HowTheAppWorksView1() })
            .accessibilityIdentifier("button_how_the_app_works")
    }
}

fileprivate struct HowTheAppWorksView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView2()) {
            PageHeader(title: LocalizedString("How Does the Tidepool Loop App Work?", comment: "Onboarding, How the App Works section, view 1, title"))
            PresentableImage(decorative: "HowTheAppWorks_1")
            Paragraph(LocalizedString("This section will explore how to use Tidepool Loop’s home screen.", comment: "Onboarding, How the App Works section, view 1, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop allows you to view information about your diabetes on one screen so you can make important treatment decisions.", comment: "Onboarding, How the App Works section, view 1, paragraph 2"))
        }
        .backButtonHidden(true)
    }
}

fileprivate struct HowTheAppWorksView2: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView3()) {
            PageHeader(title: LocalizedString("Navigating Tidepool Loop", comment: "Onboarding, How the App Works section, view 2, title"))
            Paragraph(LocalizedString("The app home screen is divided into three main areas:", comment: "Onboarding, How the App Works section, view 2, paragraph 1"))
            segment1
            segment2
            segment3
            Paragraph(LocalizedString("Let's learn more about each of these.", comment: "Onboarding, How the App Works section, view 2, segment 3, paragraph 2"))
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Status Icons", comment: "Onboarding, How the App Works section, view 2, segment 1, header")) {
            PresentableImage(decorative: "HowTheAppWorks_2_1")
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Charts", comment: "Onboarding, How the App Works section, view 2, segment 2, header")) {
            PresentableImage(decorative: "HowTheAppWorks_2_2")
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Toolbar", comment: "Onboarding, How the App Works section, view 2, segment 3, header")) {
            PresentableImage(decorative: "HowTheAppWorks_2_3")
        }
    }
}

fileprivate struct HowTheAppWorksView3: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView4()) {
            PageHeader(title: LocalizedString("Status Icons", comment: "Onboarding, How the App Works section, view 3, title"))
            PresentableImage(decorative: "HowTheAppWorks_3")
            Paragraph(LocalizedString("The top of the Tidepool Loop app has tappable status icons to check in on the components of your system.", comment: "Onboarding, How the App Works section, view 3, paragraph"))
        }
    }
}

fileprivate struct HowTheAppWorksView4: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView5()) {
            PageHeader(title: LocalizedString("CGM Status", comment: "Onboarding, How the App Works section, view 4, title"))
            PresentableImage(decorative: "HowTheAppWorks_4_1")
            Paragraph(LocalizedString("The CGM Status icon allows you to see your current glucose and rate of change arrow.", comment: "Onboarding, How the App Works section, view 4, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_4_2")
            Paragraph(LocalizedString("A progress bar will appear below these icons to let you know that scheduled maintenance – like a sensor change – is coming up.", comment: "Onboarding, How the App Works section, view 4, paragraph 2"))
            Paragraph(LocalizedString("You can tap the icon or your glucose chart for more details.", comment: "Onboarding, How the App Works section, view 4, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView5: View {
    @Environment(\.loopStatusColorPalette) private var loopStatusColors
    
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView6()) {
            PageHeader(title: LocalizedString("Automation Status", comment: "Onboarding, How the App Works section, view 5, title"))
            Callout(
                .note,
                title: Text(
                    "Automating Insulin Delivery",
                    comment: "Onboarding, How the App Works section, view 5, callout"
                )
            ) {
                Text(LocalizedString("With a regular insulin pump, insulin is given on a fixed schedule set by you and your healthcare provider.", comment: "Onboarding, How the App Works section, view 5, callout, paragraph 1"))
                Text(LocalizedString("Tidepool Loop starts with this schedule, but automatically adjusts how much insulin you get. It may give a little more or a little less insulin — either by changing your basal or by giving small automatic boluses — to help keep your glucose in range.", comment: "Onboarding, How the App Works section, view 5, callout, paragraph 2"))
            }
            .padding(.horizontal, -16)
            PresentableImage(decorative: "HowTheAppWorks_5_1")
            segment1
            segment2
            segment3
            segment4
            segment5
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Tidepool Loop Status", comment: "Onboarding, How the App Works section, view 5, segment 1, header")) {
            Paragraph(LocalizedString("When automation is ON and working, Tidepool Loop will make a calculation as often as every 5 minutes to adjust your insulin in an effort to reach your glucose Correction Range and reduce highs and lows.", comment: "Onboarding, How the App Works section, view 5, segment 1, paragraph 1"))
            Paragraph(LocalizedString("The Tidepool Loop status icon allows you to see if automation is on and working.", comment: "Onboarding, How the App Works section, view 5, segment 1, paragraph 2"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Closed Loop ON", comment: "Onboarding, How the App Works section, view 5, segment 2, header")) {
            HStack(alignment: .top, spacing: 10) {
                LoopCircleView(closedLoop: true, freshness: .fresh)
                Paragraph(LocalizedString("Loop is closed and green. You’ve set automation to ON and it’s working as expected.", comment: "Onboarding, How the App Works section, view 5, segment 2, list, item 1, paragraph"))
            }
            HStack(alignment: .top, spacing: 10) {
                LoopCircleView(closedLoop: true, freshness: .stale)
                VStack(alignment: .leading, spacing: 16) {
                    Paragraph(LocalizedString("Loop is closed and gray. You turned automation ON, but it isn’t working right now.", comment: "Onboarding, How the App Works section, view 5, segment 2, list, item 2, paragraph 1"))
                    Paragraph(LocalizedString("During this time, tap to see more details and check for communication issues with your pump and CGM.", comment: "Onboarding, How the App Works section, view 5, segment 2, list, item 2, paragraph 2"))
                    Paragraph(LocalizedString("You will also see a gray loop during Sensor Warmup.", comment: "Onboarding, How the App Works section, view 5, segment 2, list, item 2, paragraph 3"))
                }
            }
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Closed Loop OFF", comment: "Onboarding, How the App Works section, view 5, segment 3, header")) {
            HStack(alignment: .top, spacing: 10) {
                LoopCircleView(closedLoop: false, freshness: .fresh)
                Paragraph(LocalizedString("Loop is open and green. Automation is OFF. Your pump and CGM will continue operating. You’ll continue to receive your scheduled basal insulin, but it will not adjust automatically.", comment: "Onboarding, How the App Works section, view 5, segment 3, list, item 1, paragraph"))
            }
            HStack(alignment: .top, spacing: 10) {
                LoopCircleView(closedLoop: true, freshness: .stale)
                VStack(alignment: .leading, spacing: 16) {
                    Paragraph(LocalizedString("Loop is open and gray. Automation is OFF and there is an issue with one of your devices.", comment: "Onboarding, How the App Works section, view 5, segment 3, list, item 2, paragraph 1"))
                    Paragraph(LocalizedString("During this time, tap to see more details and check for communication issues with your pump and CGM.", comment: "Onboarding, How the App Works section, view 5, segment 3, list, item 2, paragraph 2"))
                }
            }
        }
    }
    
    private func freshnessColor(for freshness: LoopCompletionFreshness) -> Color {
        switch freshness {
        case .fresh: return .primary
        case .aging: return Color(loopStatusColors.warning)
        case .stale: return Color(loopStatusColors.error)
        }
    }
    
    @ViewBuilder
    private func statusView(freshness: LoopCompletionFreshness, _ text: Text) -> some View {
        Group {
            Text("\(Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")) ") + text
        }
        .foregroundStyle(freshnessColor(for: freshness))
        .font(.footnote)
        .fontWeight(.semibold)
    }
    
    private var segment4: some View {
        Segment(header: LocalizedString("Connectivity Status", comment: "Onboarding, How the App Works section, view 5, segment 4, header")) {
            PresentableImage(decorative: "HowTheAppWorks_5_2")
            Paragraph(LocalizedString("When Closed Loop is ON, the time since the last completed “loop” is displayed on the home screen, with more details in the modal.", comment: "Onboarding, How the App Works section, view 5, segment 4, paragraph 1"))
            Paragraph(LocalizedString("If the last sync time is orange or red, be sure to check for possible issues with your devices.", comment: "Onboarding, How the App Works section, view 5, segment 4, paragraph 2"))
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 24) {
                GridRow(alignment: .top) {
                    statusView(freshness: .fresh, Text("1 min ago"))
                    Text("Black").bold().foregroundStyle(freshnessColor(for: .fresh)) + Text(" indicates your last loop was successful within the last 5 minutes.")
                }
                GridRow(alignment: .top) {
                    statusView(freshness: .aging, Text("6 mins ago"))
                    Text("Orange").bold().foregroundStyle(freshnessColor(for: .aging)) + Text(" indicates it’s been 6-15 minutes since your last successful loop.")
                }
                GridRow(alignment: .top) {
                    statusView(freshness: .stale, Text("16 mins ago"))
                    Text("Red").bold().foregroundStyle(freshnessColor(for: .stale)) + Text(" indicates it’s been more than 15 minutes since your last successful loop.")
                }
            }
        }
    }
    
    private var segment5: some View {
        Segment(header: LocalizedString("Additional Information", comment: "Onboarding, How the App Works section, view 5, segment 5, header")) {
            Paragraph(LocalizedString("Tap the status icon at any time for more information.", comment: "Onboarding, How the App Works section, view 5, segment 5, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_5_3")
            Paragraph(LocalizedString("If there is a problem with automation, the gray status icon will pulse.", comment: "Onboarding, How the App Works section, view 5, segment 4, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_5_4")
        }
    }
}

fileprivate struct HowTheAppWorksView6: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView7()) {
            PageHeader(title: LocalizedString("Insulin Delivery Status", comment: "Onboarding, How the App Works section, view 6, title"))
            Paragraph(LocalizedString("When automation is on, Tidepool Loop manages your insulin dosing by adjusting both your basal and bolus insulin, as often as every 5 minutes.", comment: "Onboarding, How the App Works section, view 6, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop’s insulin delivery status icon has four states to show you whether the app is delivering your scheduled basal rate OR more/less than your scheduled delivery.", comment: "Onboarding, How the App Works section, view 6, paragraph 2"))
            Paragraph(LocalizedString("This information is displayed in the Pump Status Icon in the top-right corner of your home screen.", comment: "Onboarding, How the App Works section, view 6, paragraph 3"))
            segment1
            segment2
            segment3
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Scheduled Delivery", comment: "Onboarding, How the App Works section, view 6, segment 1, header")) {
            PresentableImage("HowTheAppWorks_6_1")
            Paragraph(BodyText(Text("When Tidepool Loop is delivering your ", comment: "Onboarding, How the App Works section, view 6, segment 1, paragraph, part 1") + Text("scheduled basal rate", comment: "Onboarding, How the App Works section, view 6, segment 1, paragraph, part 2").bold() + Text(" you will see an arrow facing to the right.", comment: "Onboarding, How the App Works section, view 6, segment 1, paragraph, part 3")))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Decreasing Delivery", comment: "Onboarding, How the App Works section, view 6, segment 2, header")) {
            PresentableImage("HowTheAppWorks_6_2")
            Paragraph(BodyText(Text("When Tidepool Loop is ", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph 1, part 1") + Text("decreasing", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph 1, part 2").bold() + Text(" your insulin delivery you will see a down arrow.", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph 1, part 3")))
            PresentableImage("HowTheAppWorks_6_3")
            Paragraph(BodyText(Text("When Tidepool Loop is ", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph 2, part 1") + Text("suspending", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph 2, part 2").bold() + Text(" your insulin delivery you will see 0 U/hr displayed below the arrow.", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph 2, part 3")))
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Increasing Delivery", comment: "Onboarding, How the App Works section, view 6, segment 3, header")) {
            PresentableImage("HowTheAppWorks_6_4")
            Paragraph(BodyText(Text("When Tidepool Loop is ", comment: "Onboarding, How the App Works section, view 6, segment 3, paragraph, part 1") + Text("increasing", comment: "Onboarding, How the App Works section, view 6, segment 3, paragraph, part 2").bold() + Text(" your insulin delivery you will see an up arrow. This includes basal insulin and automated boluses.", comment: "Onboarding, How the App Works section, view 6, segment 3, paragraph, part 3")))
        }
    }
}

fileprivate struct HowTheAppWorksView7: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView8()) {
            PageHeader(title: LocalizedString("Insulin Pump Status", comment: "Onboarding, How the App Works section, view 7, title"))
            PresentableImage("HowTheAppWorks_7_1")
            Paragraph(LocalizedString("The Insulin Pump Status icon allows you to see how much insulin remains in your pump’s reservoir or cartridge.", comment: "Onboarding, How the App Works section, view 7, paragraph 1"))
            PresentableImage("HowTheAppWorks_7_2")
            Paragraph(LocalizedString("A progress bar will appear below these icons to let you know that scheduled maintenance – like a reservoir change or a site change – is coming up.", comment: "Onboarding, How the App Works section, view 7, paragraph 2"))
            Paragraph(LocalizedString("You can tap this icon for more details.", comment: "Onboarding, How the App Works section, view 7, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView8: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView9()) {
            PageHeader(title: LocalizedString("Temporary Status Banners", comment: "Onboarding, How the App Works section, view 8, title"))
            PresentableImage("HowTheAppWorks_8_1")
            Paragraph(LocalizedString("Tidepool Loop will display a banner below the status icons to notify you of a temporary status.", comment: "Onboarding, How the App Works section, view 8, paragraph 1"))
            Paragraph(LocalizedString("You can see and interact with this banner in situations like these:", comment: "Onboarding, How the App Works section, view 8, paragraph 2"))
            BulletedListView(bulletAlignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("To track the progress or stop delivery of a bolus in progress", comment: "Onboarding, How the App Works section, view 8, list, item 1")
                    PresentableImage("HowTheAppWorks_8_2")
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("To add a fingerstick glucose value when sensor is unavailable", comment: "Onboarding, How the App Works section, view 8, list, item 2")
                    PresentableImage("HowTheAppWorks_8_3")
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("When your pump is manually suspended", comment: "Onboarding, How the App Works section, view 8, list, item 3")
                    PresentableImage("HowTheAppWorks_8_4")
                }
            }
        }
    }
}

fileprivate struct HowTheAppWorksView9: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView10()) {
            PageHeader(title: LocalizedString("Charts", comment: "Onboarding, How the App Works section, view 9, title"))
            PresentableImage(decorative: "HowTheAppWorks_9")
            Paragraph(LocalizedString("The biggest part of the home screen has three tappable charts so you can see how your glucose is changing and how your insulin and the carbs you’ve entered are working to impact your glucose.", comment: "Onboarding, How the App Works section, view 9, paragraph 1"))
            Paragraph(LocalizedString("Let’s walk through each of these charts and their features in more detail.", comment: "Onboarding, How the App Works section, view 9, paragraph 2"))
        }
    }
}

fileprivate struct HowTheAppWorksView10: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView11()) {
            PageHeader(title: LocalizedString("Glucose Chart", comment: "Onboarding, How the App Works section, view 10, title"))
            PresentableImage(decorative: "HowTheAppWorks_10_1")
            Paragraph(LocalizedString("The Glucose Chart shows you three important pieces of information about your glucose:", comment: "Onboarding, How the App Works section, view 10, paragraph 1"))
            BulletedBodyTextList(
                LocalizedString("Where it’s been", comment: "Onboarding, How the App Works section, view 10, list, item 1"),
                LocalizedString("Where it could be going", comment: "Onboarding, How the App Works section, view 10, list, item 2"),
                LocalizedString("Where you want to be", comment: "Onboarding, How the App Works section, view 10, list, item 3")
            )
            Paragraph(LocalizedString("To see a longer period of time, rotate your phone into landscape view.", comment: "Onboarding, How the App Works section, view 10, paragraph 2"))
            segment1
            segment2
            segment3
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Glucose History", comment: "Onboarding, How the App Works section, view 10, segment 1, header")) {
            PresentableImage(decorative: "HowTheAppWorks_10_2")
            Paragraph(LocalizedString("A dotted purple line shows your recent Glucose History over the last 60-90 minutes.", comment: "Onboarding, How the App Works section, view 10, segment 1, paragraph 1"))
            Paragraph(LocalizedString("Your current glucose is visible at the end of this dotted line.", comment: "Onboarding, How the App Works section, view 10, segment 1, paragraph 2"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Glucose Prediction", comment: "Onboarding, How the App Works section, view 10, segment 2, header")) {
            PresentableImage(decorative: "HowTheAppWorks_10_3")
            Paragraph(LocalizedString("A light dashed purple line shows your Glucose Prediction — how the app predicts your glucose may change over the next few hours.", comment: "Onboarding, How the App Works section, view 10, segment 2, paragraph 1"))
            Paragraph(LocalizedString("When automation is on, Tidepool Loop will update this prediction as often as every 5 minutes as it works to bring your glucose into your Correction Range.", comment: "Onboarding, How the App Works section, view 10, segment 2, paragraph 2"))
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Correction Range", comment: "Onboarding, How the App Works section, view 10, segment 3, header")) {
            PresentableImage(decorative: "HowTheAppWorks_10_4")
            Paragraph(LocalizedString("Your Correction Range will be displayed by a purple shaded horizontal bar.", comment: "Onboarding, How the App Works section, view 10, segment 3, paragraph 1"))
            Paragraph(LocalizedString("Your Correction Range is very important in Tidepool Loop. It can be a single number or a range of values that you (and your healthcare provider) want Tidepool Loop to aim for in adjusting your insulin delivery.", comment: "Onboarding, How the App Works section, view 10, segment 3, paragraph 2"))
            Paragraph(LocalizedString("This is typically a narrower range than your target range for high and low glucose notifications on your CGM. This number should be where you want your glucose to be.", comment: "Onboarding, How the App Works section, view 10, segment 3, paragraph 3"))
            Paragraph(LocalizedString("You can also tap or rotate the chart for more details.", comment: "Onboarding, How the App Works section, view 10, segment 3, paragraph 4"))
        }
    }
}

fileprivate struct HowTheAppWorksView11: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView12()) {
            PageHeader(title: LocalizedString("Tapping the Glucose Chart", comment: "Onboarding, How the App Works section, view 11, title"))
            PresentableImage(decorative: "HowTheAppWorks_11_1")
            Paragraph(LocalizedString("Most of the information you need about your glucose is visible from the home screen itself, but tapping the Glucose Chart allows you to see and do more:", comment: "Onboarding, How the App Works section, view 11, paragraph 1"))
            BulletedBodyTextList(
                LocalizedString("Understand how Tidepool Loop makes its glucose predictions", comment: "Onboarding, How the App Works section, view 11, list, item 1")
            )
            segment1
            segment2
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("When to Use a Meter", comment: "Onboarding, How the App Works section, view 11, segment 1, header")) {
            PresentableImage(decorative: "HowTheAppWorks_11_2")
            Paragraph(LocalizedString("Tidepool Loop allows you the opportunity to manually enter fingerstick glucose values from a blood glucose (BG) meter when you need to, like:", comment: "Onboarding, How the App Works section, view 11, segment 1, paragraph 1"))
            CheckmarkedBodyTextList(
                LocalizedString("During your sensor warm-up", comment: "Onboarding, How the App Works section, view 11, segment 1, list 1, item 1"),
                LocalizedString("During periods of CGM signal loss", comment: "Onboarding, How the App Works section, view 11, segment 1, list 1, item 2"),
                LocalizedString("When you want to deliver a bolus but don’t have recent sensor glucose data", comment: "Onboarding, How the App Works section, view 11, segment 1, list 1, item 3")
            )
            Paragraph(LocalizedString("You may also choose to a use a meter without entering a value in the app:", comment: "Onboarding, How the App Works section, view 11, segment 1, paragraph 2"))
            CheckmarkedBodyTextList(
                LocalizedString("When your symptoms don’t match your sensor glucose", comment: "Onboarding, How the App Works section, view 11, segment 1, list 2, item")
            )
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Adding Fingerstick Glucose", comment: "Onboarding, How the App Works section, view 11, segment 2, header")) {
            Paragraph(LocalizedString("You can add a fingerstick value directly from the temporary status banner on your home screen when you do not have sensor data available.", comment: "Onboarding, How the App Works section, view 11, segment 2, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_11_3")
            Paragraph(LocalizedString("Tidepool Loop can use fingerstick values to adjust your bolus recommendations and insulin delivery when no sensor value is available.", comment: "Onboarding, How the App Works section, view 11, segment 2, paragraph 2"))
            Paragraph(LocalizedString("After you enter a fingerstick value, Tidepool Loop may or may not recommend a bolus.", comment: "Onboarding, How the App Works section, view 11, segment 2, paragraph 3"))
            PresentableImage(decorative: "HowTheAppWorks_11_4")
            Callout(
                .note,
                title: Text(
                    "Sensor vs Fingerstick",
                    comment: "Onboarding, How the App Works section, view 11, segment 2, callout 1, title"
                ),
                message: Text(
                    "Tidepool Loop is designed to work best with sensor glucose. Some features of automation may be less effective when sensor values are unavailable.",
                    comment: "Onboarding, How the App Works section, view 11, segment 2, callout 1, paragraph"
                )
            )
            .padding(.horizontal, -16)
            Callout(
                .note,
                title: Text(
                    "No Bolus Recommendation",
                    comment: "Onboarding, How the App Works section, view 11, segment 2, callout 2, title"
                )
            ) {
                Text("There may be times a bolus will not be recommended. This can happen when:", comment: "Onboarding, How the App Works section, view 11, segment 2, callout 2, paragraph")
                BulletedListView(bulletColor: .primary, bulletOpacity: 1, bulletSize: 3, bulletAlignment: .firstTextBaseline) {
                    Text("Your glucose is predicted to be below your correction range", comment: "Onboarding, How the App Works section, view 11, segment 2, callout 2, bullet 1")
                    Text("If you’re delivering insulin for a meal and you have enough active insulin to cover the carbs you’ve entered", comment: "Onboarding, How the App Works section, view 11, segment 2, callout 2, bullet 2")
                }
                .padding(.leading, 8)
            }
            .padding(.horizontal, -16)
        }
    }
}

fileprivate struct HowTheAppWorksView12: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView13()) {
            PageHeader(title: LocalizedString("Highs and Lows", comment: "Onboarding, How the App Works section, view 12, title"))
            Callout(
                .note,
                title: Text(
                    "About Highs and Lows",
                    comment: "Onboarding, How the App Works section, view 12, callout, title"
                ),
                message: Text(
                    "Tidepool Loop cannot prevent all highs and lows.",
                    comment: "Onboarding, How the App Works section, view 12, callout, paragraph"
                )
            )
            .padding(.horizontal, -16)
            segment1
            segment2
            segment3
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("When to Step in with Treatment", comment: "Onboarding, How the App Works section, view 12, segment 1, header")) {
            PresentableImage(decorative: "HowTheAppWorks_12_1")
            Paragraph(LocalizedString("When you see a prediction of high or low glucose over the next few hours, Tidepool recommends that you watch the prediction as it updates over the course of the next few loop cycles to decide whether or not to intervene.", comment: "Onboarding, How the App Works section, view 12, segment 1, paragraph"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Have Fast-Acting Glucose On Hand for Lows", comment: "Onboarding, How the App Works section, view 12, segment 2, header")) {
            PresentableImage(decorative: "HowTheAppWorks_12_2")
            Paragraph(LocalizedString("If low glucose is predicted in the near future, you will want to take action sooner.", comment: "Onboarding, How the App Works section, view 12, segment 2, paragraph 1"))
            Paragraph(LocalizedString("You may want to have a source of fast-acting glucose nearby in case the prediction does not begin to bend toward your correction range.", comment: "Onboarding, How the App Works section, view 12, segment 2, paragraph 2"))
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Tag-teaming Lows with Closed Loop", comment: "Onboarding, How the App Works section, view 12, segment 3, header")) {
            PresentableImage(decorative: "HowTheAppWorks_12_3")
            Paragraph(LocalizedString("Remember that Tidepool Loop will also be working to bring your low glucose up.", comment: "Onboarding, How the App Works section, view 12, segment 3, paragraph 1"))
            Paragraph(LocalizedString("You may want to experiment with smaller amounts of glucose than you used to treat lows when on traditional pump or injection therapy.", comment: "Onboarding, How the App Works section, view 12, segment 3, paragraph 2"))
            Paragraph(LocalizedString("Enter any rescue carbs that you eat into the app so that it has the right information to help avoid rebound low or high glucose.", comment: "Onboarding, How the App Works section, view 12, segment 3, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView13: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView14()) {
            PageHeader(title: LocalizedString("Active Insulin Chart", comment: "Onboarding, How the App Works section, view 13, title"))
            Callout(
                .note,
                title: Text(
                    "A New Way to Think About Active Insulin",
                    comment: "Onboarding, How the App Works section, view 13, callout, title"
                ),
                message: Text(
                    "Unlike traditional pump therapy, Tidepool Loop takes into account not just your bolus insulin but all of the insulin your pump has delivered, including temporary basal rates from automation.",
                    comment: "Onboarding, How the App Works section, view 13, callout, paragraph"
                )
            )
            .padding(.horizontal, -16)
            PresentableImage(decorative: "HowTheAppWorks_13_1")
            Paragraph(LocalizedString("The second chart on the home screen is the Active Insulin chart.", comment: "Onboarding, How the App Works section, view 13, paragraph 1"))
            Paragraph(LocalizedString("It shows you how much insulin Tidepool Loop thinks is working in your body and predicts how much insulin is working over the next few hours.", comment: "Onboarding, How the App Works section, view 13, paragraph 2"))
            Paragraph(LocalizedString("You will notice a peak in the Active Insulin graph when you have delivered a manual bolus or when the system delivered an automatic bolus.", comment: "Onboarding, How the App Works section, view 13, paragraph 3"))
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("Negative Active Insulin", comment: "Onboarding, How the App Works section, view 13, segment, header")) {
            PresentableImage(decorative: "HowTheAppWorks_13_2")
            Paragraph(LocalizedString("You may occasionally see negative values if you have less insulin active in your body than usually scheduled for this time. This can happen:", comment: "Onboarding, How the App Works section, view 13, segment, paragraph"))
            BulletedBodyTextList(
                LocalizedString("When less than your usual scheduled basal was delivered", comment: "Onboarding, How the App Works section, view 13, segment, list, item 1"),
                LocalizedString("If your insulin pump was suspended", comment: "Onboarding, How the App Works section, view 13, segment, list, item 2")
            )
        }
    }
}

fileprivate struct HowTheAppWorksView14: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView15()) {
            PageHeader(title: LocalizedString("Bolus Doses", comment: "Onboarding, How the App Works section, view 14, title"))
            Paragraph(LocalizedString("Your Active Insulin chart shows recent boluses, along with the time and amount of your last meal or correction bolus.", comment: "Onboarding, How the App Works section, view 14, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_14_1")
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("Basal and Bolus Insulin Doses", comment: "Onboarding, How the App Works section, view 14, segment, header")) {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 24) {
                GridRow {
                    AccessibleImage("HowTheAppWorks_14_2", width: 16)
                    Text("Meal and correction boluses", comment: "Onboarding, How the App Works section, view 14, segment, bullet 1, part 1").bold() + Text(" are displayed as two downward triangles.", comment: "Onboarding, How the App Works section, view 14, segment, bullet 1, part 2")
                }
                GridRow {
                    AccessibleImage("HowTheAppWorks_14_3", width: 12)
                    Text("Automated boluses", comment: "Onboarding, How the App Works section, view 14, segment, bullet 2, part 1").bold() + Text(" are displayed as a dot. You can see the exact amount of each automated bolus by tapping on the chart.", comment: "Onboarding, How the App Works section, view 14, segment, bullet 2, part 2")
                }
            }
            .padding(.horizontal)
        }
    }
}

fileprivate struct HowTheAppWorksView15: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView16()) {
            PageHeader(title: LocalizedString("Tapping the Insulin Charts", comment: "Onboarding, How the App Works section, view 15, title"))
            Paragraph(LocalizedString("Tapping the Active Insulin chart allows you to see details about your current insulin delivery and a log of insulin events from the last 24 hours.", comment: "Onboarding, How the App Works section, view 15, paragraph"))
            PresentableImage(decorative: "HowTheAppWorks_15")
        }
    }
}

fileprivate struct HowTheAppWorksView16: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView17()) {
            PageHeader(title: LocalizedString("Active Carbohydrates Chart", comment: "Onboarding, How the App Works section, view 16, title"))
            Callout(
                .note,
                title: Text(
                    "A New Way to Think About Carbs",
                    comment: "Onboarding, How the App Works section, view 16, callout, title"
                ),
                message: Text(
                    "This is a concept that may be new to you if you’re coming from traditional pump or injection therapy.",
                    comment: "Onboarding, How the App Works section, view 16, callout, paragraph"
                )
            )
            .padding(.horizontal, -16)
            PresentableImage(decorative: "HowTheAppWorks_16")
            Paragraph(LocalizedString("The Active Carbohydrates Chart displays the carbs you've entered. It also shows you how Tidepool Loop thinks they will affect your glucose levels over time.", comment: "Onboarding, How the App Works section, view 16, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop needs to know about all the carbs you eat to make accurate predictions about what it thinks will happen to your glucose levels.", comment: "Onboarding, How the App Works section, view 16, paragraph 2"))
            Paragraph(LocalizedString("You can also tap or rotate the chart for more details.", comment: "Onboarding, How the App Works section, view 16, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView17: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView18()) {
            PageHeader(title: LocalizedString("Tapping the Carbs Chart", comment: "Onboarding, How the App Works section, view 17, title"))
            PresentableImage(decorative: "HowTheAppWorks_17_1")
            Paragraph(LocalizedString("Most of the information you need about your carbs is visible from the home screen itself, but tapping the Active Carbohydrates Chart allows you to see and do more:", comment: "Onboarding, How the App Works section, view 17, paragraph"))
            BulletedBodyTextList(
                LocalizedString("See your recent carbohydrate history log", comment: "Onboarding, How the App Works section, view 17, list, item 1"),
                LocalizedString("Enter information about carbs you have not already recorded", comment: "Onboarding, How the App Works section, view 17, list, item 2"),
                LocalizedString("Make certain edits to your carb history if carbs were not eaten or an incorrect entry was made", comment: "Onboarding, How the App Works section, view 17, list, item 3")
            )
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("Editing Carb Information", comment: "Onboarding, How the App Works section, view 17, segment, header")) {
            Paragraph(LocalizedString("If carbs were logged that did not get eaten, or if information was incorrectly entered, you can make changes to the log.", comment: "Onboarding, How the App Works section, view 17, segment, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_17_2")
            Paragraph(LocalizedString("To change a carb amount or time, tap the row of the entry you want to change.", comment: "Onboarding, How the App Works section, view 17, segment, paragraph 2"))
            PresentableImage(decorative: "HowTheAppWorks_17_3")
            Paragraph(LocalizedString("To remove an entry, tap Edit.", comment: "Onboarding, How the App Works section, view 17, segment, paragraph 3"))
            PresentableImage(decorative: "HowTheAppWorks_17_4")
            Paragraph(LocalizedString("Select the red minus icon next to your entry to delete. You can also swipe any item left to delete it.", comment: "Onboarding, How the App Works section, view 17, segment, paragraph 4"))
            Callout(
                .note,
                title: Text(
                    "Adding and Removing Info",
                    comment: "Onboarding, How the App Works section, view 17, callout, title"
                ),
                message: Text(
                    "Tidepool Loop will adjust your insulin based on the data in this log. Please take care when adjusting these numbers to avoid over-delivery and under-delivery of insulin.",
                    comment: "Onboarding, How the App Works section, view 17, callout, paragraph"
                )
            )
            .padding(.horizontal, -16)
        }
    }
}

fileprivate struct HowTheAppWorksView18: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView19()) {
            PageHeader(title: LocalizedString("Toolbar", comment: "Onboarding, How the App Works section, view 18, title"))
            PresentableImage(decorative: "HowTheAppWorks_18")
            Paragraph(LocalizedString("At the bottom of the home screen, you’ll see a toolbar with four buttons for some of the most common actions you’ll take in the app.", comment: "Onboarding, How the App Works section, view 18, paragraph 1"))
            Paragraph(LocalizedString("Each of these buttons allows you to tell Tidepool Loop important information for the app to act on. Let’s explore how they work.", comment: "Onboarding, How the App Works section, view 18, paragraph 2"))
        }
    }
}

fileprivate struct HowTheAppWorksView19: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView20()) {
            PageHeader(title: LocalizedString("Carb Entry", comment: "Onboarding, How the App Works section, view 19, title"))
            PresentableImage(decorative: "HowTheAppWorks_19_1")
            Paragraph(LocalizedString("Tapping the Carb Entry button allows you to enter details about what you are eating.", comment: "Onboarding, How the App Works section, view 19, paragraph"))
            PresentableImage(decorative: "HowTheAppWorks_19_2")
            segment1
            segment2
            segment3
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Absorption Time", comment: "Onboarding, How the App Works section, view 19, segment 1, header")) {
            Paragraph(LocalizedString("Different food types can affect glucose in different ways. Some foods may raise glucose quickly and others more slowly over time.", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 1"))
            Paragraph(LocalizedString("In Tidepool Loop, this difference in time and effect on glucose is called absorption time.", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 2"))
            Paragraph(LocalizedString("You can estimate how many hours you think a food may continue to impact your glucose by selecting a food type emoji preset to indicate:", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 3"))
            Segment {
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_19_Fast")
                    Paragraph(LocalizedString("Fast carb effect: 30 minutes", comment: "Onboarding, How the App Works section, view 19, segment 1, list 1, item 1, paragraph"))
                        .font(.subheadline)
                }
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_19_Medium")
                    Paragraph(LocalizedString("Medium carb effect: 3 Hours", comment: "Onboarding, How the App Works section, view 19, segment 1, list 1, item 2, paragraph"))
                        .font(.subheadline)
                }
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_19_Slow")
                    Paragraph(LocalizedString("Slow carb effect: 5 hours", comment: "Onboarding, How the App Works section, view 19, segment 1, list 1, item 3, paragraph"))
                        .font(.subheadline)
                }
            }
            Segment {
                HStack(spacing: 10) {
                    EncircledImage(decorative: "HowTheAppWorks_19_Fast")
                    Image(frameworkImage: "HowTheAppWorks_19_FastGraph", decorative: true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                HStack(spacing: 10) {
                    EncircledImage(decorative: "HowTheAppWorks_19_Medium")
                    Image(frameworkImage: "HowTheAppWorks_19_MediumGraph", decorative: true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                HStack(spacing: 10) {
                    EncircledImage(decorative: "HowTheAppWorks_19_Slow")
                    Image(frameworkImage: "HowTheAppWorks_19_SlowGraph", decorative: true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Meal Bolus", comment: "Onboarding, How the App Works section, view 19, segment 2, header")) {
            Paragraph(LocalizedString("When you click Continue, the bolus entry screen will open automatically.", comment: "Onboarding, How the App Works section, view 19, segment 2, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_19_3")
            Paragraph(LocalizedString("Always check the Active Carbs and Active Insulin to make sure the bolus amount seems right to you.", comment: "Onboarding, How the App Works section, view 19, segment 2, paragraph 2"))
            Paragraph(LocalizedString("You can save and deliver the bolus, or you can tap the Bolus amount to input your own value using the numeric keyboard.", comment: "Onboarding, How the App Works section, view 19, segment 2, paragraph 3"))
            PresentableImage(decorative: "HowTheAppWorks_19_4")
            Paragraph(LocalizedString("In order to save the carb entry without bolusing, you can enter 0 U bolus amount.", comment: "Onboarding, How the App Works section, view 19, segment 2, paragraph 4"))
            PresentableImage(decorative: "HowTheAppWorks_19_5")
            Paragraph(LocalizedString("You’ll be asked to confirm with your device’s authentication method.", comment: "Onboarding, How the App Works section, view 19, segment 2, paragraph 5"))
            Callout(.note, title: Text("No Bolus Recommendation", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, title")) {
                Text(LocalizedString("There may be times a bolus will not be recommended after carb entry. This can happen when:", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, paragraph"))
                BulletedListView(bulletColor: .primary, bulletOpacity: 1, bulletSize: 3, bulletAlignment: .firstTextBaseline) {
                    Text("You have enough active insulin to cover the carbs you’ve entered or", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, list, item 1")
                    Text("If your glucose is predicted to be below your correction range", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, list, item 2")
                }
            }
            .padding(.horizontal, -16)
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Deleting and Editing Carb Entries", comment: "Onboarding, How the App Works section, view 19, segment 3, header")) {
            Callout(.note, title: Text("Deleting and Editing Carb Entries", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, title")) {
                Text(LocalizedString("If you have incorrect carbohydrate details saved, the app may not have up-to-date information.", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, paragraph 1"))
                Text(LocalizedString("If the bolus amount doesn’t look right to you, check both your Active Carbohydrates Status Screen and your Insulin Delivery Status Screen before proceeding with the bolus.", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, paragraph 2"))
                Text(LocalizedString("You can delete or edit carb entries from this screen.", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, paragraph 3"))
            }
            .padding(.horizontal, -16)
            PresentableImage(decorative: "HowTheAppWorks_19_6")
        }
    }
    
    private struct EncircledImage: View {
        private let name: String
        private let decorative: Bool
        private let width: CGFloat
        
        @ScaledMetric private var scalingFactor: CGFloat = 1
        
        init(_ name: String, width: CGFloat = 44) {
            self.name = name
            self.decorative = false
            self.width = width
        }
        
        init(decorative name: String, width: CGFloat = 44) {
            self.name = name
            self.decorative = true
            self.width = width
        }
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: width * scalingFactor, height: width * scalingFactor)
                AccessibleImage(decorative: name, width: width / 2)
            }
        }
    }
}

fileprivate struct HowTheAppWorksView20: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView21()) {
            PageHeader(title: LocalizedString("Bolus Entry", comment: "Onboarding, How the App Works section, view 20, title"))
            PresentableImage(decorative: "HowTheAppWorks_20_1")
            Paragraph(LocalizedString("The Bolus Entry button allows you to deliver bolus insulin to bring down high glucose.", comment: "Onboarding, How the App Works section, view 20, paragraph"))
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("Delivering a Bolus", comment: "Onboarding, How the App Works section, view 20, segment, header")) {
            PresentableImage(decorative: "HowTheAppWorks_20_2")
            Paragraph(LocalizedString("If a bolus is recommended, you’ll see the amount in the Recommended Bolus field. You can accept it, or you can input your own value using the numeric keyboard that appears when you tap into the Bolus field.", comment: "Onboarding, How the App Works section, view 20, segment, paragraph 1"))
            Paragraph(LocalizedString("If the bolus amount doesn’t look right to you, check both your Active Carbohydrates Status screen and your Insulin Delivery Status screen before proceeding with the bolus.", comment: "Onboarding, How the App Works section, view 20, segment, paragraph 2"))
            Paragraph(LocalizedString("Tap Save and Deliver to send the command to your pump.", comment: "Onboarding, How the App Works section, view 20, segment, paragraph 3"))
            PresentableImage(decorative: "HowTheAppWorks_20_3")
            Paragraph(LocalizedString("You’ll be asked to confirm with your device’s authentication method (Face ID or Touch ID).", comment: "Onboarding, How the App Works section, view 20, segment, paragraph 4"))
            PresentableImage(decorative: "HowTheAppWorks_20_4")
            Paragraph(LocalizedString("You can watch the progress of your bolus as it’s delivered via the temporary status banner on the app’s home screen. You can stop the bolus by tapping the stop icon in the banner.", comment: "Onboarding, How the App Works section, view 20, segment, paragraph 5"))
        }
    }
}

fileprivate struct HowTheAppWorksView21: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView22()) {
            PageHeader(title: LocalizedString("Presets", comment: "Onboarding, How the App Works section, view 21, title"))
            PresentableImage(decorative: "HowTheAppWorks_21_1")
            Paragraph(LocalizedString("By tapping the Presets button, you can temporarily adjust your settings for events like exercise, illness, or hormonal changes that may affect your diabetes management.", comment: "Onboarding, How the App Works section, view 21, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop includes both pre-configured presets and the ability to create custom presets, providing a flexible starting point that you can tailor to your specific needs.", comment: "Onboarding, How the App Works section, view 21, paragraph 2"))
            Paragraph(LocalizedString("When a preset is on, you’ll notice the following indicators on the home screen:", comment: "Onboarding, How the App Works section, view 21, paragraph 3"))
            PresentableImage(decorative: "HowTheAppWorks_21_2")
            BulletedListView {
                Text("a banner will display at the top of the home screen", comment: "Onboarding, How the App Works section, view 21, bullet 1")
            }
            PresentableImage(decorative: "HowTheAppWorks_21_3")
            BulletedListView {
                Text("(if applicable) the glucose chart will show your adjusted correction range", comment: "Onboarding, How the App Works section, view 21, bullet 2")
            }
            PresentableImage(decorative: "HowTheAppWorks_21_4")
            BulletedListView {
                Text("the Presets button will display with inverted colors on the toolbar", comment: "Onboarding, How the App Works section, view 21, bullet 3")
            }
            segment
        }
    }
        
    private var segment: some View {
        Segment(header: LocalizedString("Bluetooth Range", comment: "Onboarding, How the App Works section, view 21, segment, header")) {
            Paragraph(LocalizedString("To use presets, your phone and diabetes devices must be within Bluetooth range (~30 feet).", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 1"))
            Paragraph(LocalizedString("If you go out of range, the system will use your last automated basal rate for 30 minutes. After that, it will use your scheduled basal rate.", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 2"))
        }
    }
}

fileprivate struct HowTheAppWorksView22: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView23()) {
            PageHeader(title: LocalizedString("Using Presets", comment: "Onboarding, How the App Works section, view 22, title"))
            PresentableImage(decorative: "HowTheAppWorks_22")
            Paragraph(LocalizedString("With a preset, you can:", comment: "Onboarding, How the App Works section, view 22, paragraph 1"))
            BulletedListView {
                Text("Adjust your overall insulin needs", comment: "Onboarding, How the App Works section, view 22, bullet 1")
                Text("Pick a temporary correction range", comment: "Onboarding, How the App Works section, view 22, bullet 2")
                Text("Choose a duration", comment: "Onboarding, How the App Works section, view 22, bullet 3")
                Text("Schedule a preset ahead of time", comment: "Onboarding, How the App Works section, view 22, bullet 4")
            }
            segment1
            segment2
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Adjusting Overall Insulin Needs", comment: "Onboarding, How the App Works section, view 22, segment 1, header")) {
            Paragraph(LocalizedString("Overall insulin should be adjusted when your body needs more or less insulin than normal.", comment: "Onboarding, How the App Works section, view 22, segment 1, paragraph"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Adjusting Correction Range", comment: "Onboarding, How the App Works section, view 22, segment 2, header")) {
            Paragraph(LocalizedString("The correction range is a safety setting. Adjusting it can help reduce the risk of low glucose if you expect unusual changes.", comment: "Onboarding, How the App Works section, view 22, segment 2, paragraph"))
        }
    }
}

fileprivate struct HowTheAppWorksView23: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView24()) {
            PageHeader(title: LocalizedString("Pre-configured Presets", comment: "Onboarding, How the App Works section, view 23, title"))
            Paragraph(LocalizedString("The app includes 5 pre-configured presets.", comment: "Onboarding, How the App Works section, view 23, paragraph 1 and 2"))
            segment1
            segment2
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Pre-Meal Preset", comment: "Onboarding, How the App Works section, view 23, segment 1, header")) {
            PresentableImage(decorative: "HowTheAppWorks_23")
            Paragraph(LocalizedString("Use the Pre-Meal preset if you want Tidepool Loop to work a bit harder before you eat, helping reduce your post-meal glucose spike.", comment: "Onboarding, How the App Works section, view 23, segment 1, paragraph 1"))
            Paragraph(LocalizedString("Activating this preset before your meal tells Tidepool Loop to adjust your insulin delivery and lower your glucose Correction Range in advance of your meal.", comment: "Onboarding, How the App Works section, view 23, segment 1, paragraph 2"))
            Paragraph(LocalizedString("When you turn on the Pre-Meal preset, it will stay on for up to one hour. Canceling it or entering a carb entry will cause it to end.", comment: "Onboarding, How the App Works section, view 23, segment 1, paragraph 3"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Presets for Activity", comment: "Onboarding, How the App Works section, view 23, segment 2, header")) {
            Paragraph(LocalizedString("Exercise and other physical activity are common times to use presets. Tidepool Loop includes preset options to support you during different types of activity.", comment: "Onboarding, How the App Works section, view 23, segment 2, paragraph 1"))
            Paragraph(LocalizedString("We designed these presets with researchers at UC Santa Barbara, the University of Pavia, Stanford University, and York University.", comment: "Onboarding, How the App Works section, view 23, segment 2, paragraph 2"))
            PresetCard.default(for: .jogging)
            PresetCard.default(for: .walking)
            PresetCard.default(for: .biking)
            PresetCard.default(for: .strengthTraining)
            Paragraph(LocalizedString("These presets are a starting point. You may need to work with your healthcare provider to edit them to meet your personal needs.", comment: "Onboarding, How the App Works section, view 23, segment 2, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView24: View {
    
    @Environment(\.colorPalette) private var colorPalette
    @EnvironmentObject private var displayGlucosePreference: DisplayGlucosePreference
    
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView25()) {
            PageHeader(title: LocalizedString("Using Presets for Activity", comment: "Onboarding, How the App Works section, view 24, title"))
            PresentableImage(decorative: "HowTheAppWorks_24")
            segment1
            segment2
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Timing Your Presets for Exercise", comment: "Onboarding, How the App Works section, view 24, segment 1, header")) {
            Text("Tidepool Loop suggests turning on a preset for exercise at least ", comment: "Onboarding, How the App Works section, view 24, segment 1, paragraph 1, part 1") + Text("1 hour before you start.", comment: "Onboarding, How the App Works section, view 24, segment 1, paragraph 1, part 2").bold()
            Text("Keep the preset on for the hour before and the whole time you are active.", comment: "Onboarding, How the App Works section, view 24, segment 1, paragraph 2")
            Text("If you forget, that’s okay. Just turn it on when you remember and leave it on until you are done.", comment: "Onboarding, How the App Works section, view 24, segment 1, paragraph 3")
            InsetContent {
                Timeline {
                    TimelineStep(
                        symbol: Image(systemName: "clock"),
                        title: Text("1 Hour Before", comment: "Onboarding, How the App Works section, view 24, segment 1, timeline, item 1, title"),
                        subtitle: Text("Enable your preset", comment: "Onboarding, How the App Works section, view 24, segment 1, timeline, item 1, subtitle")
                    )
                    TimelineStep(
                        symbol: Image(systemName: "figure.run"),
                        title:  Text("During Activity", comment: "Onboarding, How the App Works section, view 24, segment 1, timeline, item 2, title"),
                        subtitle:  Text("Keep preset on throughout your exercise", comment: "Onboarding, How the App Works section, view 24, segment 1, timeline, item 2, subtitle")
                    )
                    TimelineStep(
                        symbol: Image(systemName: "checkmark"),
                        symbolInset: 2,
                        title:  Text("Activity Ends", comment: "Onboarding, How the App Works section, view 24, segment 1, timeline, item 3, title"),
                        subtitle:  Text("Turn off preset when you finish exercising", comment: "Onboarding, How the App Works section, view 24, segment 1, timeline, item 3, subtitle")
                    )
                }
            }
            Text("You can plan ahead and schedule presets to start at a certain date and time. The app will send you a reminder and ask if you'd like to start the preset.", comment: "Onboarding, How the App Works section, view 24, segment 1, paragraph 4")
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Safe Glucose Ranges for Exercise", comment: "Onboarding, How the App Works section, view 24, segment 2, header")) {
            Paragraph(LocalizedString("Before starting exercise, make sure to check your glucose.", comment: "Onboarding, How the App Works section, view 24, segment 2, paragraph 1"))
            Paragraph(LocalizedString("Aim for your glucose to be between 120 and 180 mg/dL before exercising. Based on current research, this can help prevent high and low levels during or after your workout.", comment: "Onboarding, How the App Works section, view 24, segment 2, paragraph 2"))
            InsetContent {
                Text("Safe Starting Glucose Range").bold()
                Group {
                    Text("\(displayGlucosePreference.format(LoopQuantity(unit: .milligramsPerDeciliter, doubleValue: 120), includeUnit: false))-\(displayGlucosePreference.format(LoopQuantity(unit: .milligramsPerDeciliter, doubleValue: 180), includeUnit: false)) ")
                        .font(.system(size: UIFontMetrics.default.scaledValue(for: 32)).weight(.heavy))
                    + Text(displayGlucosePreference.unit.localizedShortUnitString)
                }
                .foregroundStyle(colorPalette.carbTintColor)
                Text("\(Image(systemName: "exclamationmark.circle")) Consider a small snack to prevent lows")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Callout(.note, message: Text("If your glucose is over 180 mg/dL, starting a preset that lowers insulin may not bring it down as much. You could stay high longer.", comment: "Onboarding, How the App Works section, view 24, segment 2, callout, message"))
                .padding(.horizontal, -16)
            Paragraph(LocalizedString("Always check your glucose before, during, and after any activity. This will help keep your glucose within a safe range.", comment: "Onboarding, How the App Works section, view 24, segment 2, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView25: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView26()) {
            PageHeader(title: LocalizedString("Preset Performance History", comment: "Onboarding, How the App Works section, view 25, title"))
            PresentableImage(decorative: "HowTheAppWorks_25")
            Paragraph(LocalizedString("Performance History shows you how each preset affected your glucose levels.", comment: "Onboarding, How the App Works section, view 25, paragraph 1"))
            Paragraph(LocalizedString("You can view a summary of your data during the preset and for the six hours after. This helps you understand how the preset worked.", comment: "Onboarding, How the App Works section, view 25, paragraph 2"))
            Paragraph(LocalizedString("To try it, tap Presets, then Performance History, and pick the preset you want to review.", comment: "Onboarding, How the App Works section, view 25, paragraph 3"))
            Paragraph(LocalizedString("Performance history is saved for up to seven days.", comment: "Onboarding, How the App Works section, view 25, paragraph 4"))
        }
    }
}

fileprivate struct HowTheAppWorksView26: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView27()) {
            PageHeader(title: LocalizedString("Settings", comment: "Onboarding, How the App Works section, view 26, title"))
            PresentableImage(decorative: "HowTheAppWorks_26_1")
            Paragraph(LocalizedString("The Settings button takes you to the Settings Screen where you can enter information about your personal insulin needs and glucose targets, your insulin pump, your CGM, and your notifications preferences.", comment: "Onboarding, How the App Works section, view 26, paragraph 1"))
            Paragraph(LocalizedString("We’ll enter these settings a little later in your setup.", comment: "Onboarding, How the App Works section, view 26, paragraph 2"))
            PresentableImage(decorative: "HowTheAppWorks_26_2")
        }
    }
}

fileprivate struct HowTheAppWorksView27: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks) {
            PageHeader(title: LocalizedString("Checkpoint", comment: "Onboarding, Introduction section, view 27, title"))
            CheckpointCheckmark()
            Paragraph(LocalizedString("Now that you’ve finished learning how the home screen of Tidepool Loop works, you’ll take a look at how you’ll use the app throughout your day.", comment: "Onboarding, Introduction section, view 27, paragraph 1"))
            Paragraph(LocalizedString("You’ve learned about:", comment: "Onboarding, Introduction section, view 27, paragraph 2"))
            CheckmarkedBodyTextList(
                LocalizedString("How Status Icons help you check in with the components", comment: "Onboarding, Introduction section, view 27, list, item 1"),
                LocalizedString("How to use Charts to see how the app is working", comment: "Onboarding, Introduction section, view 27, list, item 2"),
                LocalizedString("How to use the Toolbar to enter details and perform important tasks", comment: "Onboarding, Introduction section, view 27, list, item 3")
            )
        }
    }
}

struct HowTheAppWorksViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.howTheAppWorks)
        return onboardingViewModel
    }()
    
    static var displayGlucosePreference: DisplayGlucosePreference = {
        return DisplayGlucosePreference.preview
    }()
    
    static var previews: some View {
        ContentPreviewWithBackground {
            HowTheAppWorksNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucosePreference)
        }
    }
}
