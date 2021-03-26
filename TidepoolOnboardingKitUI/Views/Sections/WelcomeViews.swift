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
                    ForEach(welcomeData.indices) { viewIndex in
                        ScrollView {
                            VStack {
                                welcome(for: viewIndex)
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

    private func welcome(for index: Int) -> some View {
        VStack(alignment: HorizontalAlignment(welcomeData[index].alignment), spacing: 20) {
            PresentableImage(welcomeData[index].image)
                .accessibilityLabel(String(format: LocalizedString("Tidepool Loop Welcome, page %d of %d", comment: "Onboarding, Welcome section, image accessibility label"), index + 1, welcomeData.count))
            Text(welcomeData[index].title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(welcomeData[index].alignment)
            if let description = welcomeData[index].description {
                Paragraph(description)
            } else {
                EmptyView()
            }
        }
    }

    private func pager(for index: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(welcomeData.indices) { viewIndex in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(viewIndex == index ? .accentColor : .gray)
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private func button(for index: Int) -> some View {
        if index < welcomeData.count - 1 {
            ActionButton(title: LocalizedString("Continue", comment: "Onboarding, Welcome section, Continue button label"), action: { selectedIndex = index + 1 })
                .accessibilityIdentifier("button_continue")
        } else {
            ActionButton(title: LocalizedString("Finish", comment: "Onboarding, Welcome section, Finish button label"), action: { onboardingViewModel.sectionProgression.completeSection(.welcome) })
                .accessibilityIdentifier("button_finish")
        }
    }
}

fileprivate let welcomeData = [
    WelcomeData(image: "Welcome_1",
                title: LocalizedString("Welcome to\nTidepool Loop", comment: "Onboarding, Welcome section, view 1, title"),
                alignment: .center),
    WelcomeData(image: "Welcome_2",
                title: LocalizedString("What is Automated Insulin Dosing?", comment: "Onboarding, Welcome section, view 2, title"),
                description: LocalizedString("An automated insulin dosing system is different than a typical insulin pump. It automatically adjusts your background (or basal) insulin in response to your glucose readings from a CGM sensor.", comment: "Onboarding, Welcome section, view 2, description")),
    WelcomeData(image: "Welcome_3",
                title: LocalizedString("What is Tidepool Loop?", comment: "Onboarding, Welcome section, view 3, title"),
                description: LocalizedString("Tidepool Loop is an app designed to automate your insulin dosing by doing the following:", comment: "Onboarding, Welcome section, view 3, description")),
    WelcomeData(image: "Welcome_4",
                title: LocalizedString("Pulling Together Information", comment: "Onboarding, Welcome section, view 4, title"),
                description: LocalizedString("about your glucose and insulin from the Bluetooth-connected diabetes devices you wear: a continuous glucose monitor (CGM) and an insulin pump.", comment: "Onboarding, Welcome section, view 4, description")),
    WelcomeData(image: "Welcome_5",
                title: LocalizedString("Connecting that Information", comment: "Onboarding, Welcome section, view 5, title"),
                description: LocalizedString("with details you enter about carbs you eat, plans for exercise, and glucose targets you’re aiming for.", comment: "Onboarding, Welcome section, view 5, description")),
    WelcomeData(image: "Welcome_6",
                title: LocalizedString("Adjusting Your Insulin Delivery", comment: "Onboarding, Welcome section, view 6, title"),
                description: LocalizedString("in the background to reduce high and low glucose and work to keep you in your target Correction Range.", comment: "Onboarding, Welcome section, view 6, description")),
    WelcomeData(image: "Welcome_7",
                title: LocalizedString("You Have a Role to Play", comment: "Onboarding, Welcome section, view 7, title"),
                description: LocalizedString("While Tidepool Loop has many features to support you in managing your diabetes, you have an important role to play in using the app safely and effectively.\n\nThat’s why you’ll need to complete this in-app learning to begin using Tidepool Loop.", comment: "Onboarding, Welcome section, view 7, description"))
]

fileprivate struct WelcomeData {
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
