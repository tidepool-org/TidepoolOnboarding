//
//  OnboardingWelcomeViews.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

let onboardingWelcomeViews: [AnyView] = [AnyView(OnboardingWelcomeTab1()),
                                         AnyView(OnboardingWelcomeTab2()),
                                         AnyView(OnboardingWelcomeTab3()),
                                         AnyView(OnboardingWelcomeTab4()),
                                         AnyView(OnboardingWelcomeTab5()),
                                         AnyView(OnboardingWelcomeTab6()),
                                         AnyView(OnboardingWelcomeTab7())]

struct OnboardingWelcomeTab1: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(frameworkImage: "Welcome_1_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("Welcome to\nTidepool Loop")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}

struct OnboardingWelcomeTab2: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(frameworkImage: "Welcome_2_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("What is Automated Insulin Dosing?")
                .font(.largeTitle)
                .bold()
            Text("An automated insulin dosing system is different than a typical insulin pump. It automatically adjusts your background (or basal) insulin in response to your glucose readings from a CGM sensor.")
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        }
    }
}

struct OnboardingWelcomeTab3: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(frameworkImage: "Welcome_3_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("What is Tidepool Loop?")
                .font(.largeTitle)
                .bold()
            Text("Tidepool Loop is an app designed to automate your insulin dosing by doing the following:")
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        }
    }
}

struct OnboardingWelcomeTab4: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(frameworkImage: "Welcome_4_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("Pulling Together Information")
                .font(.largeTitle)
                .bold()
            Text("about your glucose and insulin from the Bluetooth-connected diabetes devices you wear: a continuous glucose monitor (CGM) and an insulin pump.")
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        }
    }
}

struct OnboardingWelcomeTab5: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(frameworkImage: "Welcome_5_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("Connecting that Information")
                .font(.largeTitle)
                .bold()
            Text("with details you enter about carbs you eat, plans for exercise, and glucose targets you’re aiming for.")
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        }
    }
}

struct OnboardingWelcomeTab6: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(frameworkImage: "Welcome_6_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("Adjusting Your Insulin Delivery")
                .font(.largeTitle)
                .bold()
            Text("in the background to reduce high and low glucose and work to keep you in your target Correction Range.")
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        }
    }
}

struct OnboardingWelcomeTab7: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(frameworkImage: "Welcome_7_Top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("You Have a Role to Play")
                .font(.largeTitle)
                .bold()
            Text("While Tidepool Loop has many features to support you in managing your diabetes, you have an important role to play in using the app safely and effectively.\n\nThat’s why you’ll need to complete this in-app learning to begin using Tidepool Loop.")
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        }
    }
}
