//
//  ADayInTheLifeViews.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct ADayInTheLifeNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .aDayInTheLife, destination: ADayInTheLifeNavigationView())
            .accessibilityIdentifier("button_a_day_in_the_life")
    }
}

fileprivate struct ADayInTheLifeNavigationView: View {
    var body: some View {
        NavigationView() {
            OnboardingSectionPagesView(sectionPages: aDayInTheLifeSectionPages)
        }
    }
}

fileprivate let aDayInTheLifeSectionPages = OnboardingSectionPages(section: .aDayInTheLife, pages: aDayInTheLifePages)
fileprivate let aDayInTheLifePages = [OnboardingPage(title: "A Day in the Life", view: EmptyView())]
