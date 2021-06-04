//
//  HowTheAppWorksViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

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
            Paragraph(LocalizedString("Let’s get acquainted with each area.", comment: "Onboarding, How the App Works section, view 2, segment 3, paragraph 2"))
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
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView6()) {
            PageHeader(title: LocalizedString("Tidepool Loop Status", comment: "Onboarding, How the App Works section, view 5, title"))
            Callout(title: LocalizedString("Note: Automating Basal Insulin", comment: "Onboarding, How the App Works section, view 5, callout")) {
                Paragraph(LocalizedString("In traditional insulin pump therapy, your basal rate delivers as a scheduled rate per hour, programmed by you and your healthcare provider.", comment: "Onboarding, How the App Works section, view 5, callout, paragraph 1"))
                Paragraph(LocalizedString("Tidepool Loop starts with this scheduled hourly rate, and then changes your basal rate automatically, often giving you more or less than your scheduled basal rate to help you keep your glucose in your Correction Range.", comment: "Onboarding, How the App Works section, view 5, callout, paragraph 2"))
            }
            PresentableImage(decorative: "HowTheAppWorks_5")
            segment1
            segment2
            segment3
            segment4
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Tidepool Loop Status", comment: "Onboarding, How the App Works section, view 5, segment 1, header")) {
            Paragraph(LocalizedString("When automation is on, Tidepool Loop will make a calculation as often as every 5 minutes to adjust your basal insulin in an effort to reach your glucose Correction Range and reduce highs and lows.", comment: "Onboarding, How the App Works section, view 5, segment 1, paragraph 1"))
            Paragraph(LocalizedString("The Tidepool Loop Status icon allows you to see if automation is on and working. You can tap the icon for more information.", comment: "Onboarding, How the App Works section, view 5, segment 1, paragraph 2"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Closed Loop ON", comment: "Onboarding, How the App Works section, view 5, segment 2, header")) {
            HStack(alignment: .top, spacing: 10) {
                LoopIcon(automation: .closed, freshness: .fresh)
                Paragraph(LocalizedString("Loop is closed and green. Automation is ON. Your last loop was successful within the last 5 minutes.", comment: "Onboarding, How the App Works section, view 5, segment 2, list, item, paragraph"))
            }
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Closed Loop OFF", comment: "Onboarding, How the App Works section, view 5, segment 3, header")) {
            HStack(alignment: .top, spacing: 10) {
                LoopIcon(automation: .open, freshness: .fresh)
                Paragraph(LocalizedString("Loop is open. Automation is OFF. Your pump and CGM will continue operating, but your basal insulin will not adjust automatically.", comment: "Onboarding, How the App Works section, view 5, segment 3, list, item, paragraph"))
            }
        }
    }
    
    private var segment4: some View {
        Segment(header: LocalizedString("Connectivity Status", comment: "Onboarding, How the App Works section, view 5, segment 4, header")) {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 10) {
                    LoopIcon(automation: .closed, freshness: .aging)
                    Segment {
                        Paragraph(LocalizedString("Loop is orange. Automation is ON, but it has been 5-15 minutes since your last loop.", comment: "Onboarding, How the App Works section, view 5, segment 4, list, item 1, paragraph 1"))
                        Paragraph(LocalizedString("Tap for additional information and watch for potential communication issues with your pump and CGM.", comment: "Onboarding, How the App Works section, view 5, segment 4, list, item 1, paragraph 2"))
                    }
                }
                HStack(alignment: .top, spacing: 10) {
                    LoopIcon(automation: .closed, freshness: .stale)
                    Segment {
                        Paragraph(LocalizedString("Loop is red. Automation is ON, but it has been more than 15 minutes since your last loop.", comment: "Onboarding, How the App Works section, view 5, segment 4, list, item 2, paragraph 1"))
                        Paragraph(LocalizedString("Tap for additional information and check for communication issues with your pump and CGM.", comment: "Onboarding, How the App Works section, view 5, segment 4, list, item 2, paragraph 2"))
                    }
                }
            }
        }
    }
}

fileprivate struct HowTheAppWorksView6: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView7()) {
            PageHeader(title: LocalizedString("Insulin Delivery Status", comment: "Onboarding, How the App Works section, view 6, title"))
            PresentableImage(decorative: "HowTheAppWorks_6")
            Paragraph(LocalizedString("Tidepool Loop’s Insulin Delivery Status icon has three states to show you whether the app is delivering your scheduled basal rate or more or less than your scheduled rate.", comment: "Onboarding, How the App Works section, view 6, paragraph 1"))
            Paragraph(LocalizedString("You can tap the icon or your insulin charts for more details.", comment: "Onboarding, How the App Works section, view 6, paragraph 2"))
            segment1
            segment2
            segment3
        }
    }
    
    private var segment1: some View {
        Segment(header: LocalizedString("Scheduled Basal Insulin", comment: "Onboarding, How the App Works section, view 6, segment 1, header")) {
            HStack(spacing: 10) {
                AccessibleImage("HowTheAppWorks_6_ScheduledBasal")
                Paragraph(LocalizedString("A flat line indicates that your basal is delivering at your scheduled basal rate for this time of day.", comment: "Onboarding, How the App Works section, view 6, segment 1, list, item, paragraph"))
            }
            Paragraph(LocalizedString("A value of 0.0 U indicates that your basal is delivering without any changes to your scheduled rate. It does not mean your basal rate is 0 U per hour.", comment: "Onboarding, How the App Works section, view 6, segment 1, paragraph"))
        }
    }
    
    private var segment2: some View {
        Segment(header: LocalizedString("Reduced Basal Insulin", comment: "Onboarding, How the App Works section, view 6, segment 2, header")) {
            HStack(spacing: 10) {
                AccessibleImage("HowTheAppWorks_6_DecreasedBasal")
                Paragraph(LocalizedString("A dropped icon indicates that your scheduled basal is reduced by the value shown.", comment: "Onboarding, How the App Works section, view 6, segment 2, list, item, paragraph"))
            }
            Paragraph(LocalizedString("A reduced basal rate will always be indicated with a negative value, i.e. -1.0 U basal means your basal is currently 1.0 U per hour less than your scheduled basal rate for this time of day.", comment: "Onboarding, How the App Works section, view 6, segment 2, paragraph"))
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Increased Basal Insulin", comment: "Onboarding, How the App Works section, view 6, segment 3, header")) {
            HStack(spacing: 10) {
                AccessibleImage("HowTheAppWorks_6_IncreasedBasal")
                Paragraph(LocalizedString("A raised icon indicates that your scheduled basal is increased by the value shown.", comment: "Onboarding, How the App Works section, view 6, segment 3, list, item, paragraph"))
            }
            Paragraph(LocalizedString("An increased basal rate will always be indicated with a positive value. +3.0 U basal means your basal is currently 3.0 U per hour more than your scheduled basal rate for this time of day.", comment: "Onboarding, How the App Works section, view 6, segment 3, paragraph"))
        }
    }
}

fileprivate struct HowTheAppWorksView7: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView8()) {
            PageHeader(title: LocalizedString("Insulin Pump Status", comment: "Onboarding, How the App Works section, view 7, title"))
            PresentableImage(decorative: "HowTheAppWorks_7_1")
            Paragraph(LocalizedString("The Insulin Pump Status icon allows you to see how much insulin remains in your pump’s reservoir or cartridge.", comment: "Onboarding, How the App Works section, view 7, paragraph 1"))
            PresentableImage(decorative: "HowTheAppWorks_7_2")
            Paragraph(LocalizedString("A progress bar will appear below these icons to let you know that scheduled maintenance – like a pod change or a site change – is coming up.", comment: "Onboarding, How the App Works section, view 7, paragraph 2"))
            Paragraph(LocalizedString("You can tap the icon or your insulin charts for more details.", comment: "Onboarding, How the App Works section, view 7, paragraph 3"))
        }
    }
}

fileprivate struct HowTheAppWorksView8: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView9()) {
            PageHeader(title: LocalizedString("Temporary Status Banners", comment: "Onboarding, How the App Works section, view 8, title"))
            PresentableImage(decorative: "HowTheAppWorks_8")
            Paragraph(LocalizedString("Tidepool Loop will drop a banner notification below these Status Icons to alert you to a temporary status.", comment: "Onboarding, How the App Works section, view 8, paragraph 1"))
            Paragraph(LocalizedString("You’ll see and can interact with this banner during situations like these:", comment: "Onboarding, How the App Works section, view 8, paragraph 2"))
            HStack(spacing: 10) {
                AccessibleImage("HowTheAppWorks_8_InProgress", width: 25)
                Paragraph(LocalizedString("To stop a bolus in progress", comment: "Onboarding, How the App Works section, view 8, paragraph 3"))
            }
            .padding(.horizontal)
            BulletedBodyTextList(
                LocalizedString("Tracking the progress of a bolus being delivered", comment: "Onboarding, How the App Works section, view 8, list, item 1"),
                LocalizedString("To add a fingerstick glucose value when sensor is unavailable", comment: "Onboarding, How the App Works section, view 8, list, item 2"),
                LocalizedString("When pump is manually suspended", comment: "Onboarding, How the App Works section, view 8, list, item 3")
            )
        }
    }
}

fileprivate struct HowTheAppWorksView9: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView10()) {
            PageHeader(title: LocalizedString("Charts", comment: "Onboarding, How the App Works section, view 9, title"))
            PresentableImage(decorative: "HowTheAppWorks_9")
            Paragraph(LocalizedString("The biggest part of the home screen has four tappable charts so you can see how your glucose is moving and how your insulin and the carbs you’ve entered are working to impact your glucose.", comment: "Onboarding, How the App Works section, view 9, paragraph 1"))
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
            Paragraph(LocalizedString("Your Correction Range is very important in Tidepool Loop. It can be a single number or a range of values that you (and your healthcare provider) want Tidepool Loop to aim for in adjusting your basal insulin.", comment: "Onboarding, How the App Works section, view 10, segment 3, paragraph 2"))
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
                LocalizedString("Understand how Tidepool Loop makes its glucose predictions", comment: "Onboarding, How the App Works section, view 11, list, item 1"),
                LocalizedString("Enter information about fingerstick glucose", comment: "Onboarding, How the App Works section, view 11, list, item 2")
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
            Paragraph(LocalizedString("Tidepool Loop can use fingerstick values to adjust your bolus recommendations and basal insulin when no sensor value is available.", comment: "Onboarding, How the App Works section, view 11, segment 2, paragraph 2"))
            PresentableImage(decorative: "HowTheAppWorks_11_4")
            Paragraph(LocalizedString("After you enter a fingerstick value, Tidepool Loop may or may not recommend a bolus. ", comment: "Onboarding, How the App Works section, view 11, segment 2, paragraph 3"))
            Callout(title: LocalizedString("Note: Sensor vs Fingerstick", comment: "Onboarding, How the App Works section, view 11, segment 2, callout, title")) {
                Paragraph(LocalizedString("Tidepool Loop is designed to work best with sensor glucose. Some features of automation may be less effective when sensor values are unavailable.", comment: "Onboarding, How the App Works section, view 11, segment 2, callout, paragraph"))
            }
        }
    }
}

fileprivate struct HowTheAppWorksView12: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView13()) {
            PageHeader(title: LocalizedString("Highs and Lows", comment: "Onboarding, How the App Works section, view 12, title"))
            Callout(title: LocalizedString("Note: About Highs and Lows", comment: "Onboarding, How the App Works section, view 12, callout, title")) {
                Paragraph(LocalizedString("Tidepool Loop cannot prevent all highs and lows.", comment: "Onboarding, How the App Works section, view 12, callout, paragraph"))
            }
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
            PresentableImage(decorative: "HowTheAppWorks_13_1")
            Paragraph(LocalizedString("The second chart on the home screen is the Active Insulin Chart.", comment: "Onboarding, How the App Works section, view 13, paragraph 1"))
            Paragraph(LocalizedString("It shows you how much insulin Tidepool Loop thinks is working in your body and predicts how much insulin is working over the next few hours.", comment: "Onboarding, How the App Works section, view 13, paragraph 2"))
            Paragraph(LocalizedString("You can also tap the chart for more details.", comment: "Onboarding, How the App Works section, view 13, paragraph 3"))
            Callout(title: LocalizedString("Note: A New Way to Think About Active Insulin", comment: "Onboarding, How the App Works section, view 13, callout, title")) {
                Paragraph(LocalizedString("Unlike traditional pump therapy, Tidepool Loop takes into account not just your bolus insulin but all of the insulin your pump has delivered, including temporary basal rates from automation.", comment: "Onboarding, How the App Works section, view 13, callout, paragraph"))
            }
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
            PageHeader(title: LocalizedString("Insulin Delivery Chart", comment: "Onboarding, How the App Works section, view 14, title"))
            PresentableImage(decorative: "HowTheAppWorks_14")
            Paragraph(LocalizedString("The Insulin Delivery Chart shows you both your basal and bolus insulin delivery history over the last few hours.", comment: "Onboarding, How the App Works section, view 14, paragraph 1"))
            Paragraph(LocalizedString("Your total insulin use for the day is displayed above the chart.", comment: "Onboarding, How the App Works section, view 14, paragraph 2"))
            Paragraph(LocalizedString("You can also tap or rotate the chart for more details.", comment: "Onboarding, How the App Works section, view 14, paragraph 3"))
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("Basal and Bolus Insulin Doses", comment: "Onboarding, How the App Works section, view 14, segment, header")) {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_14_Bolus", width: 20)
                        .padding(.horizontal, 6 * scalingFactor)
                    Paragraph(LocalizedString("Boluses of insulin are presented as blue triangles.", comment: "Onboarding, How the App Works section, view 14, segment, list, item 1, paragraph"))
                }
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_14_Basal", width: 33)
                    Paragraph(LocalizedString("Basal insulin is presented as a series of blue bars that correspond to each change of the insulin delivery status icon.", comment: "Onboarding, How the App Works section, view 14, segment, list, item 2, paragraph"))
                }
            }
            .padding(.horizontal)
        }
    }

    @ScaledMetric private var scalingFactor: CGFloat = 1
}

fileprivate struct HowTheAppWorksView15: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView16()) {
            PageHeader(title: LocalizedString("Tapping the Insulin Charts", comment: "Onboarding, How the App Works section, view 15, title"))
            PresentableImage(decorative: "HowTheAppWorks_15")
            Paragraph(LocalizedString("Most of the information you need about your insulin is visible from the home screen itself, but tapping either of the insulin charts allows you to see your recent insulin history log.", comment: "Onboarding, How the App Works section, view 15, paragraph"))
        }
    }
}

fileprivate struct HowTheAppWorksView16: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView17()) {
            PageHeader(title: LocalizedString("Active Carbohydrates Chart", comment: "Onboarding, How the App Works section, view 16, title"))
            Callout(title: LocalizedString("Note: A New Way to Think About Carbs", comment: "Onboarding, How the App Works section, view 16, callout, title")) {
                Paragraph(LocalizedString("This is a concept that may be new to you if you’re coming from traditional pump or injection therapy.", comment: "Onboarding, How the App Works section, view 16, callout, paragraph"))
            }
            PresentableImage(decorative: "HowTheAppWorks_16")
            Paragraph(LocalizedString("The Active Carbohydrates Chart shows the carbs that you've entered into the app and how Tidepool Loop expects them to impact your glucose over time.", comment: "Onboarding, How the App Works section, view 16, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop needs to know about all of the carbs that you eat in order to update and make its best predictions about your glucose.", comment: "Onboarding, How the App Works section, view 16, paragraph 2"))
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
            Callout(title: LocalizedString("Note: Adding and Removing Info", comment: "Onboarding, How the App Works section, view 17, callout, title")) {
                Paragraph(LocalizedString("Tidepool Loop will adjust your insulin based on the data in this log. Please take care when adjusting these numbers to avoid over-delivery and under-delivery of insulin.", comment: "Onboarding, How the App Works section, view 17, callout, paragraph"))
            }
        }
    }
}

fileprivate struct HowTheAppWorksView18: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView19()) {
            PageHeader(title: LocalizedString("Toolbar", comment: "Onboarding, How the App Works section, view 18, title"))
            PresentableImage(decorative: "HowTheAppWorks_18")
            Paragraph(LocalizedString("At the bottom of the home screen, you’ll see a toolbar with five buttons for some of the most common actions you’ll take in the app.", comment: "Onboarding, How the App Works section, view 18, paragraph 1"))
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
            Paragraph(LocalizedString("Absorption time may be a new concept for you if you’re coming from traditional pump or injection therapy. Let’s explore.", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 1"))
            Paragraph(LocalizedString("Different food types can affect glucose in different ways. Some foods may raise glucose quickly and others more slowly over time.", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 2"))
            Paragraph(LocalizedString("In Tidepool Loop, this difference in time and effect on glucose is called absorption time.", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 3"))
            Paragraph(LocalizedString("You can estimate how many hours you think a food may continue to impact your glucose by selecting a food type emoji preset to indicate:", comment: "Onboarding, How the App Works section, view 19, segment 1, paragraph 4"))
            Segment {
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_19_Fast")
                    Paragraph(LocalizedString("Fast carb effect: 30 minutes", comment: "Onboarding, How the App Works section, view 19, segment 1, list 1, item 1, paragraph"))
                }
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_19_Medium")
                    Paragraph(LocalizedString("Medium carb effect: 3 Hours", comment: "Onboarding, How the App Works section, view 19, segment 1, list 1, item 2, paragraph"))
                }
                HStack(spacing: 10) {
                    AccessibleImage("HowTheAppWorks_19_Slow")
                    Paragraph(LocalizedString("Slow carb effect: 5 hours", comment: "Onboarding, How the App Works section, view 19, segment 1, list 1, item 3, paragraph"))
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
            Paragraph(LocalizedString("You’ll be asked to confirm with your device’s authentication method (Face ID or Touch ID).", comment: "Onboarding, How the App Works section, view 19, segment 2, paragraph 5"))
            Callout(title: LocalizedString("Note: No Bolus Recommendation", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, title")) {
                Paragraph(LocalizedString("There may be times a bolus will not be recommended after carb entry. This can happen when:", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, paragraph"))
                BulletedBodyTextList(
                    LocalizedString("You have enough active insulin to cover the carbs you’ve entered or", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, list, item 1"),
                    LocalizedString("If your glucose is predicted to be below your correction range", comment: "Onboarding, How the App Works section, view 19, segment 2, callout, list, item 2")
                )
            }
        }
    }
    
    private var segment3: some View {
        Segment(header: LocalizedString("Deleting and Editing Carb Entries", comment: "Onboarding, How the App Works section, view 19, segment 3, header")) {
            Callout(title: LocalizedString("Note: Deleting and Editing Carb Entries", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, title")) {
                Paragraph(LocalizedString("If you have incorrect carbohydrate details saved, the app may not have up-to-date information.", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, paragraph 1"))
                Paragraph(LocalizedString("If the bolus amount doesn’t look right to you, check both your Active Carbohydrates Status Screen and your Insulin Delivery Status Screen before proceeding with the bolus.", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, paragraph 2"))
                Paragraph(LocalizedString("You can delete or edit carb entries from this screen.", comment: "Onboarding, How the App Works section, view 19, segment 3, callout, paragraph 3"))
            }
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
            PageHeader(title: LocalizedString("Pre-Meal Preset", comment: "Onboarding, How the App Works section, view 20, title"))
            PresentableImage(decorative: "HowTheAppWorks_20_1")
            Paragraph(LocalizedString("If you’d like Tidepool Loop to temporarily work a little harder before you begin eating so that your post-meal glucose spike is reduced, you can use Pre-Meal Preset.", comment: "Onboarding, How the App Works section, view 20, paragraph 1"))
            Paragraph(LocalizedString("Activating this feature before your meal tells Tidepool Loop to adjust your basal insulin and lower your glucose Correction Range to your Pre-Meal Range in advance of your meal.", comment: "Onboarding, How the App Works section, view 20, paragraph 2"))
            PresentableImage(decorative: "HowTheAppWorks_20_2")
            Paragraph(LocalizedString("The Pre-Meal Preset will be in effect for up to one hour or until you cancel it or enter your next carb entry.", comment: "Onboarding, How the App Works section, view 20, paragraph 3"))
            Paragraph(LocalizedString("When activated, the button will display with inverted colors as shown above.", comment: "Onboarding, How the App Works section, view 20, paragraph 4"))
        }
    }
}

fileprivate struct HowTheAppWorksView21: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView22()) {
            PageHeader(title: LocalizedString("Bolus Entry", comment: "Onboarding, How the App Works section, view 21, title"))
            PresentableImage(decorative: "HowTheAppWorks_21_1")
            Paragraph(LocalizedString("The Bolus Entry button allows you to deliver bolus insulin to bring down high glucose.", comment: "Onboarding, How the App Works section, view 21, paragraph"))
            segment
        }
    }
    
    private var segment: some View {
        Segment(header: LocalizedString("Delivering a Bolus", comment: "Onboarding, How the App Works section, view 21, segment, header")) {
            PresentableImage(decorative: "HowTheAppWorks_21_2")
            Paragraph(LocalizedString("If a bolus is recommended, you’ll see the amount in the Recommended Bolus field. You can accept it, or you can input your own value using the numeric keyboard that appears when you tap into the Bolus field.", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 1"))
            Paragraph(LocalizedString("If the bolus amount doesn’t look right to you, check both your Active Carbohydrates Status screen and your Insulin Delivery Status screen before proceeding with the bolus.", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 2"))
            Paragraph(LocalizedString("Tap Save and Deliver to send the command to your pump.", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 3"))
            PresentableImage(decorative: "HowTheAppWorks_21_3")
            Paragraph(LocalizedString("You’ll be asked to confirm with your device’s authentication method (Face ID or Touch ID).", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 4"))
            PresentableImage(decorative: "HowTheAppWorks_21_4")
            Paragraph(LocalizedString("You can watch the progress of your bolus as it’s delivered via the temporary status banner on the app’s home screen. You can stop the bolus by tapping the stop icon in the banner.", comment: "Onboarding, How the App Works section, view 21, segment, paragraph 5"))
        }
    }
}

fileprivate struct HowTheAppWorksView22: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView23()) {
            PageHeader(title: LocalizedString("Workout Preset", comment: "Onboarding, How the App Works section, view 22, title"))
            PresentableImage(decorative: "HowTheAppWorks_22_1")
            Paragraph(LocalizedString("If you’d like Tidepool Loop to temporarily adjust your settings for activity, such as exercise, you can use Workout Preset.", comment: "Onboarding, How the App Works section, view 22, paragraph 1"))
            Paragraph(LocalizedString("Activating this button before activity tells Tidepool Loop to adjust both your basal insulin and your glucose Correction Range to help you meet your glucose goals during that activity.", comment: "Onboarding, How the App Works section, view 22, paragraph 2"))
            PresentableImage(decorative: "HowTheAppWorks_22_2")
            Paragraph(LocalizedString("Workout Preset will be in effect for the time you indicate when you activate it or until you cancel it.", comment: "Onboarding, How the App Works section, view 22, paragraph 3"))
            Paragraph(LocalizedString("When activated, the button will display with inverted colors as shown above, and the glucose chart will show the adjustment (your Workout Range) as shown below.", comment: "Onboarding, How the App Works section, view 22, paragraph 4"))
            PresentableImage(decorative: "HowTheAppWorks_22_3")
        }
    }
}

fileprivate struct HowTheAppWorksView23: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, destination: HowTheAppWorksView24()) {
            PageHeader(title: LocalizedString("Settings", comment: "Onboarding, How the App Works section, view 23, title"))
            PresentableImage(decorative: "HowTheAppWorks_23_1")
            Paragraph(LocalizedString("The Settings button takes you to the Settings Screen where you can enter information about your personal insulin needs and glucose targets, your insulin pump, your CGM, and your notifications preferences.", comment: "Onboarding, How the App Works section, view 23, paragraph 1"))
            Paragraph(LocalizedString("We’ll enter these settings a little later in your setup.", comment: "Onboarding, How the App Works section, view 23, paragraph 2"))
            PresentableImage(decorative: "HowTheAppWorks_23_2")
        }
    }
}

fileprivate struct HowTheAppWorksView24: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks) {
            PageHeader(title: LocalizedString("Checkpoint", comment: "Onboarding, Introduction section, view 24, title"))
            CheckpointCheckmark()
            Paragraph(LocalizedString("Now that you’ve finished learning how the home screen of Tidepool Loop works, you’ll take a look at how you’ll use the app throughout your day.", comment: "Onboarding, Introduction section, view 24, paragraph 1"))
            Paragraph(LocalizedString("You’ve learned about:", comment: "Onboarding, Introduction section, view 24, paragraph 2"))
            CheckmarkedBodyTextList(
                LocalizedString("How Status Icons help you check in with the components", comment: "Onboarding, Introduction section, view 24, list, item 1"),
                LocalizedString("How to use Charts to see how the app is working", comment: "Onboarding, Introduction section, view 24, list, item 2"),
                LocalizedString("How to use the Toolbar to enter details and perform important tasks", comment: "Onboarding, Introduction section, view 24, list, item 3")
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
    
    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()
    
    static var previews: some View {
        ContentPreviewWithBackground {
            HowTheAppWorksNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
