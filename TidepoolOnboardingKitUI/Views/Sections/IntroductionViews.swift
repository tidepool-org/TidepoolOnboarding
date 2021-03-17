//
//  IntroductionViews.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct IntroductionNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .introduction, destination: IntroductionNavigationView())
            .accessibilityIdentifier("button_introduction")
    }
}

fileprivate struct IntroductionNavigationView: View {
    var body: some View {
        NavigationView() {
            OnboardingSectionPagesView(sectionPages: introductionSectionPages)
        }
    }
}

fileprivate let introductionSectionPages = OnboardingSectionPages(section: .introduction, pages: introductionPages)
fileprivate let introductionPages = [OnboardingPage(title: "Introduction 1", view: EmptyView()),
                                     OnboardingPage(title: "Introduction 2", view: EmptyView()),
                                     OnboardingPage(title: "Introduction 3", view: EmptyView())]
