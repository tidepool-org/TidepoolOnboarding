//
//  HowTheAppWorksViews.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct HowTheAppWorksNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .howTheAppWorks, destination: HowTheAppWorksNavigationView())
            .accessibilityIdentifier("button_how_the_app_works")
    }
}

fileprivate struct HowTheAppWorksNavigationView: View {
    var body: some View {
        NavigationView() {
            OnboardingSectionPagesView(sectionPages: howTheAppWorksSectionPages)
        }
    }
}

fileprivate let howTheAppWorksSectionPages = OnboardingSectionPages(section: .howTheAppWorks, pages: howTheAppWorksPages)
fileprivate let howTheAppWorksPages = [OnboardingPage(title: "How the App Works", view: EmptyView())]
