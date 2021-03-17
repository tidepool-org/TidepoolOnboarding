//
//  WelcomeViews.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct WelcomeTabView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var selectedIndex = 0

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                TabView(selection: $selectedIndex) {
                    ForEach(welcomeViews.indices) { viewIndex in
                        ScrollView {
                            VStack {
                                welcomeViews[viewIndex]
                                Spacer()
                                pager(for: viewIndex)
                                    .padding(.vertical)
                                button(for: viewIndex)
                            }
                            .padding()
                            .frame(minHeight: geometry.size.height)
                        }
                        .tag(viewIndex)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onAppear { onboardingViewModel.sectionProgression.startSection(.welcome) }
    }

    private func pager(for index: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(welcomeViews.indices) { viewIndex in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(viewIndex == index ? .accentColor : .gray)
            }
        }
        .accessibilityElement()
        .accessibilityAddTraits(.isStaticText)
        .accessibilityLabel(String(format: LocalizedString("%d of %d", comment: "Welcome tab view pager"), index + 1, welcomeViews.count))
    }

    @ViewBuilder
    private func button(for index: Int) -> some View {
        if index < welcomeViews.count - 1 {
            ActionButton(title: LocalizedString("Continue", comment: "Label for Continue button in welcome tab view"), action: { selectedIndex = index + 1 })
                .accessibilityIdentifier("button_continue")
        } else {
            ActionButton(title: LocalizedString("Finish", comment: "Label for Finish button in welcome tab view"), action: { onboardingViewModel.sectionProgression.completeSection(.welcome) })
                .accessibilityIdentifier("button_finish")
        }
    }
}

fileprivate let welcomeViews = [
    WelcomeView(image: "Welcome_1_Top",
                title: LocalizedString("Welcome to\nTidepool Loop", comment: "Title of Welcome to Tidepool Loop Welcome view"),
                alignment: .center),
    WelcomeView(image: "Welcome_2_Top",
                title: LocalizedString("What is Automated Insulin Dosing?", comment: "Title of What is Automated Insulin Dosing Welcome view"),
                description: LocalizedString("An automated insulin dosing system is different than a typical insulin pump. It automatically adjusts your background (or basal) insulin in response to your glucose readings from a CGM sensor.", comment: "Description in What is Automated Insulin Dosing Welcome view")),
    WelcomeView(image: "Welcome_3_Top",
                title: LocalizedString("What is Tidepool Loop?", comment: "Title of What is Tidepool Loop Welcome view"),
                description: LocalizedString("Tidepool Loop is an app designed to automate your insulin dosing by doing the following:", comment: "Description in What is Tidepool Loop Welcome view")),
    WelcomeView(image: "Welcome_4_Top",
                title: LocalizedString("Pulling Together Information", comment: "Title of Pulling Together Information Welcome view"),
                description: LocalizedString("about your glucose and insulin from the Bluetooth-connected diabetes devices you wear: a continuous glucose monitor (CGM) and an insulin pump.", comment: "Description in Pulling Together Information Welcome view")),
    WelcomeView(image: "Welcome_5_Top",
                title: LocalizedString("Connecting that Information", comment: "Title of Connecting that Information Welcome view"),
                description: LocalizedString("with details you enter about carbs you eat, plans for exercise, and glucose targets you’re aiming for.", comment: "Description in Connecting that Information Welcome view")),
    WelcomeView(image: "Welcome_6_Top",
                title: LocalizedString("Adjusting Your Insulin Delivery", comment: "Title of Adjusting Your Insulin Delivery Welcome view"),
                description: LocalizedString("in the background to reduce high and low glucose and work to keep you in your target Correction Range.", comment: "Description in Adjusting Your Insulin Delivery Welcome view")),
    WelcomeView(image: "Welcome_7_Top",
                title: LocalizedString("You Have a Role to Play", comment: "Title of You Have a Role to Play Welcome view"),
                description: LocalizedString("While Tidepool Loop has many features to support you in managing your diabetes, you have an important role to play in using the app safely and effectively.\n\nThat’s why you’ll need to complete this in-app learning to begin using Tidepool Loop.", comment: "Description in You Have a Role to Play Welcome view"))
]

fileprivate struct WelcomeView: View {
    let image: String
    let title: String
    let description: String?
    let alignment: TextAlignment

    init(image: String, title: String, description: String? = nil, alignment: TextAlignment = .leading) {
        self.image = image
        self.title = title
        self.description = description
        self.alignment = alignment
    }

    var body: some View {
        VStack(alignment: HorizontalAlignment(alignment), spacing: 20) {
            imageView
            titleView
            descriptionView
        }
    }

    private var imageView: some View {
        Image(frameworkImage: image, decorative: true)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }

    private var titleView: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(alignment)
    }

    @ViewBuilder
    private var descriptionView: some View {
        if let description = description {
            Text(description)
                .font(.body)
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        } else {
            EmptyView()
        }
    }
}

fileprivate extension HorizontalAlignment {
    init(_ alignment: TextAlignment) {
        switch alignment {
        case .leading:
            self = .leading
        case .center:
            self = .center
        case .trailing:
            self = .trailing
        }
    }
}
