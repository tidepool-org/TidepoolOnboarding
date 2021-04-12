//
//  ADayInTheLifeViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct ADayInTheLifeNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .aDayInTheLife, destination: NavigationViewWithNavigationBarAppearance { ADayInTheLifeView1() })
            .accessibilityIdentifier("button_a_day_in_the_life")
    }
}

fileprivate struct ADayInTheLifeView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, backButtonHidden: true, destination: ADayInTheLifeView2()) {
            PageHeader(title: LocalizedString("A Day in the Life with Tidepool Loop", comment: "Onboarding, A Day In The Life section, view 1, title"), page: 1, of: 25)
            Paragraph(LocalizedString("Let’s take a look at how Tidepool Loop can help you handle four daily diabetes scenarios.", comment: "Onboarding, A Day In The Life section, view 1, paragraph"))
            BulletedBodyTextList(
                LocalizedString("Eating", comment: "Onboarding, A Day In The Life section, view 1, list, item 1"),
                LocalizedString("Exercising", comment: "Onboarding, A Day In The Life section, view 1, list, item 2"),
                LocalizedString("Sleeping", comment: "Onboarding, A Day In The Life section, view 1, list, item 3"),
                LocalizedString("Dealing with highs and lows", comment: "Onboarding, A Day In The Life section, view 1, list, item 4")
            )
        }
    }
}

fileprivate struct ADayInTheLifeView2: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView3()) {
            PageHeader(title: LocalizedString("Eating with Tidepool Loop", comment: "Onboarding, A Day In The Life section, view 2, title"), page: 2, of: 25)
            PresentableImage(decorative: "ADayInTheLife_2_1")
            Paragraph(LocalizedString("It’s lunch time and you’re thinking about a big sandwich and chips from your favorite local cafe around the corner from your office.", comment: "Onboarding, A Day In The Life section, view 2, paragraph 1"))
            Paragraph(LocalizedString("Tidepool Loop shows that your glucose is 120 mg/dL.", comment: "Onboarding, A Day In The Life section, view 2, paragraph 2"))
            PresentableImage(decorative: "ADayInTheLife_2_2")
            Paragraph(LocalizedString("Your charts show little insulin or carbs active in your body.", comment: "Onboarding, A Day In The Life section, view 2, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView3: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView4()) {
            PageHeader(title: LocalizedString("Using Pre-Meal Preset", comment: "Onboarding, A Day In The Life section, view 3, title"), page: 3, of: 25)
            PresentableImage(decorative: "ADayInTheLife_3")
            Paragraph(LocalizedString("Tidepool Loop has maintained your glucose in your usual Correction Range, but you know this meal often sends you higher than you’d like.", comment: "Onboarding, A Day In The Life section, view 3, paragraph 1"))
            Paragraph(LocalizedString("You can use Pre-Meal Preset to have Tidepool Loop adjust your insulin delivery to bring you into a lower glucose range between now and your meal so that you start the meal with a lower glucose.", comment: "Onboarding, A Day In The Life section, view 3, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView4: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView5()) {
            PageHeader(title: LocalizedString("Entering Carbs", comment: "Onboarding, A Day In The Life section, view 4, title"), page: 4, of: 25)
            Paragraph(LocalizedString("You get to the cafe and see that it’s quite busy. Tapping the Carb Entry button from either the app Toolbar or your Apple Watch, you decide to enter your carb entry for 15 minutes into the future.", comment: "Onboarding, A Day In The Life section, view 4, paragraph 1"))
            Paragraph(LocalizedString("You estimate that the sandwich is around 40g and the chips will be around 25g, or 65g total.", comment: "Onboarding, A Day In The Life section, view 4, paragraph 2"))
            PresentableImage(decorative: "ADayInTheLife_4_1")
            Paragraph(LocalizedString("You don’t have to be precise.", comment: "Onboarding, A Day In The Life section, view 4, paragraph 3"))
            Paragraph(LocalizedString("Tidepool Loop will watch how your glucose responds, recalculate your estimate, and adjust your basal insulin in an effort to reduce highs and lows.", comment: "Onboarding, A Day In The Life section, view 4, paragraph 4"))
            segment
        }
    }

    private var segment: some View {
        Segment(header: LocalizedString("Choosing a Food Type", comment: "Onboarding, A Day In The Life section, view 4, segment, header")) {
            Paragraph(LocalizedString("Since this is a meal that you know typically affects your glucose for a few hours, you select the taco preset for an absorption time of 3 hours, or medium carb effect.", comment: "Onboarding, A Day In The Life section, view 4, segment, paragraph 1"))
            PresentableImage(decorative: "ADayInTheLife_4_2")
            Paragraph(LocalizedString("Alright. You’ve entered 65g of carb, you’ve set the time for 15 minutes in the future, and you’ve selected a food type.", comment: "Onboarding, A Day In The Life section, view 4, segment, paragraph 2"))
            Paragraph(LocalizedString("You'll tap Continue to tell Tidepool Loop you'll be eating those carbs and proceed to the Bolus Screen.", comment: "Onboarding, A Day In The Life section, view 4, segment, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView5: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView6()) {
            PageHeader(title: LocalizedString("Time to Bolus", comment: "Onboarding, A Day In The Life section, view 5, title"), page: 5, of: 25)
            Paragraph(LocalizedString("After you enter your carbs, the Bolus Entry Screen will automatically appear.", comment: "Onboarding, A Day In The Life section, view 5, paragraph 1"))
            PresentableImage(decorative: "ADayInTheLife_5")
            Paragraph(LocalizedString("You can see the Active Carbs and Active Insulin at the top of the screen that show how the app is calculating this bolus.", comment: "Onboarding, A Day In The Life section, view 5, paragraph 2"))
            Paragraph(LocalizedString("Check that these numbers make sense to you.", comment: "Onboarding, A Day In The Life section, view 5, paragraph 3"))
            Paragraph(LocalizedString("With the phone in Bluetooth range of the pump, tap Save and Deliver to send the bolus command.", comment: "Onboarding, A Day In The Life section, view 5, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView6: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView7()) {
            PageHeader(title: LocalizedString("Let’s Eat", comment: "Onboarding, A Day In The Life section, view 6, title"), page: 6, of: 25)
            PresentableImage(decorative: "ADayInTheLife_6")
            Paragraph(LocalizedString("When your sandwich arrives, you’re all set.", comment: "Onboarding, A Day In The Life section, view 6, paragraph 1"))
            Paragraph(LocalizedString("If you decide not to finish all of your meal, you can go back and edit the carb entry in your Active Carbohydrates list to reflect what you actually ate.", comment: "Onboarding, A Day In The Life section, view 6, paragraph 2"))
            Paragraph(LocalizedString("Tidepool Loop will continue to adjust your basal insulin over the next three hours with the knowledge that you have these carbs working to impact your glucose.", comment: "Onboarding, A Day In The Life section, view 6, paragraph 3"))
            Paragraph(LocalizedString("Thanks, Tidepool Loop.", comment: "Onboarding, A Day In The Life section, view 6, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView7: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView8()) {
            PageHeader(title: LocalizedString("Sleeping with Tidepool Loop", comment: "Onboarding, A Day In The Life section, view 7, title"), page: 7, of: 25)
            PresentableImage(decorative: "ADayInTheLife_7")
            Paragraph(LocalizedString("One of the benefits of automated insulin dosing for many people with diabetes and their loved ones is sleeping with fewer interruptions from low and high glucose.", comment: "Onboarding, A Day In The Life section, view 7, paragraph 1"))
            Paragraph(LocalizedString("Let’s look at how Tidepool Loop can impact your night.", comment: "Onboarding, A Day In The Life section, view 7, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView8: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView9()) {
            PageHeader(title: LocalizedString("Goodnight, App", comment: "Onboarding, A Day In The Life section, view 8, title"), page: 8, of: 25)
            PresentableImage(decorative: "ADayInTheLife_8")
            Paragraph(LocalizedString("Before you go to sleep, check in with your home screen status icons to ensure that the app is running.", comment: "Onboarding, A Day In The Life section, view 8, paragraph 1"))
            Paragraph(LocalizedString("Make sure that your phone is charging or has enough battery to last the night and that your pump has enough insulin.", comment: "Onboarding, A Day In The Life section, view 8, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView9: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView10()) {
            PageHeader(title: LocalizedString("While Sleeping", comment: "Onboarding, A Day In The Life section, view 9, title"), page: 9, of: 25)
            PresentableImage(decorative: "ADayInTheLife_9")
            Paragraph(LocalizedString("If automation is on, Tidepool Loop will work while you sleep to help keep you in your correction range without your intervention.", comment: "Onboarding, A Day In The Life section, view 9, paragraph 1"))
            Paragraph(LocalizedString("If automation is off, or if you are trending low or high before bed, you may want to take additional action or monitor more closely to prevent low and high glucose.", comment: "Onboarding, A Day In The Life section, view 9, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView10: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView11()) {
            PageHeader(title: LocalizedString("Nighttime Checks", comment: "Onboarding, A Day In The Life section, view 10, title"), page: 10, of: 25)
            PresentableImage(decorative: "ADayInTheLife_10")
            Paragraph(LocalizedString("While Tidepool Loop will continue to actively adjust insulin delivery through the night, there may be times when you want to be more vigilant with your diabetes during the night, such as after a larger-than-usual dinner, an active day, or during illness.", comment: "Onboarding, A Day In The Life section, view 10, paragraph 1"))
            Paragraph(LocalizedString("You know your (or your loved one’s) diabetes and will develop your own level of trust with Tidepool Loop in your own time. You can more actively monitor as you see fit.", comment: "Onboarding, A Day In The Life section, view 10, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView11: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView12()) {
            PageHeader(title: LocalizedString("Rise and Shine", comment: "Onboarding, A Day In The Life section, view 11, title"), page: 11, of: 25)
            PresentableImage(decorative: "ADayInTheLife_11")
            Paragraph(LocalizedString("When you wake up, you can look back over the history of Tidepool Loop’s actions it took while you were sleeping. Looks like your glucose stayed flat much of the night.", comment: "Onboarding, A Day In The Life section, view 11, paragraph 1"))
            Paragraph(LocalizedString("Thanks, Tidepool Loop.", comment: "Onboarding, A Day In The Life section, view 11, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView12: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView13()) {
            PageHeader(title: LocalizedString("Exercising with Tidepool Loop", comment: "Onboarding, A Day In The Life section, view 12, title"), page: 12, of: 25)
            PresentableImage(decorative: "ADayInTheLife_12_1")
            Paragraph(LocalizedString("With Tidepool Loop, you have both information and automation to help you prepare for activity.", comment: "Onboarding, A Day In The Life section, view 12, paragraph 1"))
            Paragraph(LocalizedString("You love to go for a 2-mile run in the mornings and have found that you like to keep your glucose around 150 mg/dL on your runs.", comment: "Onboarding, A Day In The Life section, view 12, paragraph 2"))
            PresentableImage(decorative: "ADayInTheLife_12_2")
            segment
        }
    }

    private var segment: some View {
        Segment(header: LocalizedString("A New Approach", comment: "Onboarding, A Day In The Life section, view 12, segment 1, header")) {
            Paragraph(LocalizedString("Before Tidepool Loop, you might have chosen to eat a snack before activities or perhaps reduce your insulin delivery before a run.", comment: "Onboarding, A Day In The Life section, view 12, segment 1, paragraph 1"))
            Paragraph(LocalizedString("With Tidepool Loop, you can use information from your charts and automation via Workout Preset to manage your exercise.", comment: "Onboarding, A Day In The Life section, view 12, segment 1, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView13: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView14()) {
            PageHeader(title: LocalizedString("Check Your Charts", comment: "Onboarding, A Day In The Life section, view 13, title"), page: 13, of: 25)
            PresentableImage(decorative: "ADayInTheLife_13")
            Paragraph(LocalizedString("About thirty minutes to an hour before your run, you check your charts.", comment: "Onboarding, A Day In The Life section, view 13, paragraph 1"))
            Paragraph(LocalizedString("Your Glucose Chart shows that your glucose is not predicted to drop in the near future.", comment: "Onboarding, A Day In The Life section, view 13, paragraph 2"))
            Paragraph(LocalizedString("Your Active Insulin Chart shows that you do not have much insulin currently working to lower your glucose.", comment: "Onboarding, A Day In The Life section, view 13, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView14: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView15()) {
            PageHeader(title: LocalizedString("Workout Preset", comment: "Onboarding, A Day In The Life section, view 14, title"), page: 14, of: 25)
            Paragraph(LocalizedString("You’ve told Tidepool Loop in Settings that you like your glucose to stay a little higher during your workouts and have set this goal for 150-160 mg/dL.", comment: "Onboarding, A Day In The Life section, view 14, paragraph 1"))
            Paragraph(LocalizedString("You go ahead and tap the Workout Preset button from either your iPhone or Apple Watch to tell Tidepool Loop to adjust both your glucose target and your insulin delivery for the next two hours.", comment: "Onboarding, A Day In The Life section, view 14, paragraph 2"))
            PresentableImage(decorative: "ADayInTheLife_14_1")
            Paragraph(LocalizedString("You decide how long before or after this change should remain in effect, as well as how long you expect your activity to last.", comment: "Onboarding, A Day In The Life section, view 14, paragraph 3"))
            Paragraph(LocalizedString("Work with your healthcare provider to find the optimal timing and settings for your individual exercise routine. You may find you want to extend your workout settings for longer before or after certain activities.", comment: "Onboarding, A Day In The Life section, view 14, paragraph 4"))
            Paragraph(LocalizedString("When your Workout Range is active, you’ll see a darker purple shaded correction range on your Glucose Chart.", comment: "Onboarding, A Day In The Life section, view 14, paragraph 5"))
            PresentableImage(decorative: "ADayInTheLife_14_2")
            Paragraph(LocalizedString("You can also see that your changes are active by the inverted button colors in the toolbar, as shown below.", comment: "Onboarding, A Day In The Life section, view 14, paragraph 6"))
            PresentableImage(decorative: "ADayInTheLife_14_3")
        }
    }
}

fileprivate struct ADayInTheLifeView15: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView16()) {
            PageHeader(title: LocalizedString("Ready to Roll", comment: "Onboarding, A Day In The Life section, view 15, title"), page: 15, of: 25)
            PresentableImage(decorative: "ADayInTheLife_15")
            Paragraph(LocalizedString("You’ll keep your phone with you on your run to keep Tidepool Loop actively working on maintaining your adjusted correction range.", comment: "Onboarding, A Day In The Life section, view 15, paragraph 1"))
            Paragraph(LocalizedString("You’ll also carry fast-acting glucose with you in case of low glucose.", comment: "Onboarding, A Day In The Life section, view 15, paragraph 2"))
        }
    }
}

fileprivate struct ADayInTheLifeView16: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView17()) {
            PageHeader(title: LocalizedString("Running Smoothly", comment: "Onboarding, A Day In The Life section, view 16, title"), page: 16, of: 25)
            PresentableImage(decorative: "ADayInTheLife_16")
            Paragraph(LocalizedString("Your feet hit the pavement.", comment: "Onboarding, A Day In The Life section, view 16, paragraph 1"))
            Paragraph(LocalizedString("You check your app or your Apple Watch along your route to see if your glucose is dropping.", comment: "Onboarding, A Day In The Life section, view 16, paragraph 2"))
            Paragraph(LocalizedString("Everything looks good. You run your best second mile you’ve run in a while.", comment: "Onboarding, A Day In The Life section, view 16, paragraph 3"))
            Paragraph(LocalizedString("Thanks, Tidepool Loop.", comment: "Onboarding, A Day In The Life section, view 16, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView17: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView18()) {
            PageHeader(title: LocalizedString("Highs and Lows", comment: "Onboarding, A Day In The Life section, view 17, title"), page: 17, of: 25)
            PresentableImage(decorative: "ADayInTheLife_17")
            Paragraph(LocalizedString("Tidepool Loop cannot prevent all high and low glucose values.", comment: "Onboarding, A Day In The Life section, view 17, paragraph 1"))
            Paragraph(LocalizedString("It’s important to understand when you will need to intervene.", comment: "Onboarding, A Day In The Life section, view 17, paragraph 2"))
            Paragraph(LocalizedString("You can use the Glucose Prediction and home screen charts to decide when it’s necessary to take action to prevent or treat highs and lows.", comment: "Onboarding, A Day In The Life section, view 17, paragraph 3"))
            Paragraph(LocalizedString("To decide whether or not you need to take additional action, ask yourself the following questions.", comment: "Onboarding, A Day In The Life section, view 17, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView18: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView19()) {
            PageHeader(title: LocalizedString("1. How Far Out is Tidepool Loop’s Prediction?", comment: "Onboarding, A Day In The Life section, view 18, title"), page: 18, of: 25)
            PresentableImage(decorative: "ADayInTheLife_18")
            Paragraph(LocalizedString("The further out the prediction is, the less accurate it will be. This is because Tidepool Loop will continue to adjust delivery as often as every 5 minutes in an effort to reach your correction range.", comment: "Onboarding, A Day In The Life section, view 18, paragraph 1"))
            Paragraph(LocalizedString("If low glucose looks likely in the near future, you may want to go ahead and treat with fast-acting carbs.", comment: "Onboarding, A Day In The Life section, view 18, paragraph 2"))
            Paragraph(LocalizedString("Entering these carbs into Tidepool Loop will adjust your glucose prediction.", comment: "Onboarding, A Day In The Life section, view 18, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView19: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView20()) {
            PageHeader(title: LocalizedString("2. Is Automation On?", comment: "Onboarding, A Day In The Life section, view 19, title"), page: 19, of: 25)
            PresentableImage(decorative: "ADayInTheLife_19_1")
            Paragraph(LocalizedString("If automation is on, Tidepool Loop will continue making adjustments in an effort to bring your glucose into your correct range.", comment: "Onboarding, A Day In The Life section, view 19, paragraph 1"))
            PresentableImage(decorative: "ADayInTheLife_19_2")
            PresentableImage(decorative: "ADayInTheLife_19_3")
            Paragraph(LocalizedString("If automation is off or seems inconsistent, you will need to respond to high and low glucose according to your healthcare provider’s instructions.", comment: "Onboarding, A Day In The Life section, view 19, paragraph 2"))
            Paragraph(LocalizedString("You may need to eat additional carbs to prevent or treat a low or take additional insulin to prevent or treat a high.", comment: "Onboarding, A Day In The Life section, view 19, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView20: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView21()) {
            PageHeader(title: LocalizedString("3. How Much Active Insulin is Working to Lower Your Glucose?", comment: "Onboarding, A Day In The Life section, view 20, title"), page: 20, of: 25)
            PresentableImage(decorative: "ADayInTheLife_20")
            Paragraph(LocalizedString("Check your Active Insulin Chart. Do you still have insulin working in your body?", comment: "Onboarding, A Day In The Life section, view 20, paragraph 1"))
            Paragraph(LocalizedString("If Tidepool Loop predicts a low and your chart shows you have insulin active in your bloodstream, you may want to eat fast-acting carbs to prevent low glucose.", comment: "Onboarding, A Day In The Life section, view 20, paragraph 2"))
            Paragraph(LocalizedString("If Tidepool Loop predicts a high, check your chart to see if you have enough insulin working to reduce it without the need for an additional bolus.", comment: "Onboarding, A Day In The Life section, view 20, paragraph 3"))
            Paragraph(LocalizedString("You can tap the Bolus Entry button at any time to see if Tidepool Loop would recommend a bolus right now.", comment: "Onboarding, A Day In The Life section, view 20, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView21: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView22()) {
            PageHeader(title: LocalizedString("4. How Many Active Carbs Are Working to Raise Your Glucose?", comment: "Onboarding, A Day In The Life section, view 21, title"), page: 21, of: 25)
            PresentableImage(decorative: "ADayInTheLife_21")
            Paragraph(LocalizedString("Check your Active Carbohydrates Chart. Do you still have carbs working in your body?", comment: "Onboarding, A Day In The Life section, view 21, paragraph 1"))
            Paragraph(LocalizedString("You may have enough carbs from a previous meal or snack to cover low glucose.", comment: "Onboarding, A Day In The Life section, view 21, paragraph 2"))
            Paragraph(LocalizedString("If you have eaten carbs that you have not entered, Tidepool Loop may predict that your glucose will go lower because it doesn’t know about those carbs.", comment: "Onboarding, A Day In The Life section, view 21, paragraph 3"))
            Paragraph(LocalizedString("You can tap the Active Carbohydrates Chart to edit, add, or delete carb entries you may have forgotten to enter. Adding a carb entry will adjust the app’s glucose prediction.", comment: "Onboarding, A Day In The Life section, view 21, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView22: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView23()) {
            PageHeader(title: LocalizedString("5. Is Your CGM Functioning Properly?", comment: "Onboarding, A Day In The Life section, view 22, title"), page: 22, of: 25)
            PresentableImage(decorative: "ADayInTheLife_22")
            Paragraph(LocalizedString("It’s always a good idea to check that your devices are working as intended.", comment: "Onboarding, A Day In The Life section, view 22, paragraph 1"))
            Paragraph(LocalizedString("If your CGM readings do not match your symptoms or a fingerstick reading from a blood glucose meter, or if you’re not getting updated readings from your sensor, your sensor may be having a problem.", comment: "Onboarding, A Day In The Life section, view 22, paragraph 2"))
            Paragraph(LocalizedString("You can tap Settings or the CGM Icon to calibrate, check the status of, or change out your sensor.", comment: "Onboarding, A Day In The Life section, view 22, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView23: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView24()) {
            PageHeader(title: LocalizedString("6. Is Your Insulin Pump Functioning Properly?", comment: "Onboarding, A Day In The Life section, view 23, title"), page: 23, of: 25)
            PresentableImage(decorative: "ADayInTheLife_23")
            Paragraph(LocalizedString("If your insulin pump cannula is kinked or occluded, Tidepool Loop may think it has delivered insulin that your body may not be absorbing.", comment: "Onboarding, A Day In The Life section, view 23, paragraph 1"))
            Paragraph(LocalizedString("Charts will show large amounts of active insulin that do not reflect what you have actually received, and your glucose prediction will be inaccurate.", comment: "Onboarding, A Day In The Life section, view 23, paragraph 2"))
            Paragraph(LocalizedString("You can tap Settings or the Insulin Pump Icons to check the status of your insulin pump or to suspend or resume insulin.", comment: "Onboarding, A Day In The Life section, view 23, paragraph 3"))
        }
    }
}

fileprivate struct ADayInTheLifeView24: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, destination: ADayInTheLifeView25()) {
            PageHeader(title: LocalizedString("7. Do You Know Something Tidepool Loop Doesn’t?", comment: "Onboarding, A Day In The Life section, view 24, title"), page: 24, of: 25)
            PresentableImage(decorative: "ADayInTheLife_24")
            Paragraph(LocalizedString("There is always a chance that YOU have information that the app does not.", comment: "Onboarding, A Day In The Life section, view 24, paragraph 1"))
            Paragraph(LocalizedString("Perhaps you know that you’re getting sick or that your activity was more strenuous than usual.", comment: "Onboarding, A Day In The Life section, view 24, paragraph 2"))
            Paragraph(LocalizedString("You know your body and your diabetes. And you know that, sometimes, diabetes doesn’t make sense.", comment: "Onboarding, A Day In The Life section, view 24, paragraph 3"))
            Paragraph(LocalizedString("In those instances, take the action you feel is necessary to keep yourself safe from the effects of low and high glucose.", comment: "Onboarding, A Day In The Life section, view 24, paragraph 4"))
        }
    }
}

fileprivate struct ADayInTheLifeView25: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife) {
            PageHeader(title: LocalizedString("Checkpoint", comment: "Onboarding, A Day In The Life section, view 25, title"), page: 25, of: 25)
            CheckpointCheckmark()
            Paragraph(LocalizedString("You’ve seen how you might use Tidepool Loop in daily life for:", comment: "Onboarding, A Day In The Life section, view 25, paragraph 1"))
            BulletedBodyTextList(
                LocalizedString("Eating", comment: "Onboarding, A Day In The Life section, view 25, list, item 1"),
                LocalizedString("Sleeping", comment: "Onboarding, A Day In The Life section, view 25, list, item 2"),
                LocalizedString("Exercising", comment: "Onboarding, A Day In The Life section, view 25, list, item 3"),
                LocalizedString("Dealing with highs and lows", comment: "Onboarding, A Day In The Life section, view 25, list, item 4")
            )
            Paragraph(LocalizedString("You know what you need to know to use Tidepool Loop's features.", comment: "Onboarding, A Day In The Life section, view 25, paragraph 2"))
            Paragraph(LocalizedString("Next you’ll enter your settings and pair your devices so you can get started!", comment: "Onboarding, A Day In The Life section, view 25, paragraph 3"))
        }
    }
}

struct ADayInTheLifeViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.aDayInTheLife)
        return onboardingViewModel
    }()

    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()

    static var previews: some View {
        ContentPreviewWithBackground {
            ADayInTheLifeNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
