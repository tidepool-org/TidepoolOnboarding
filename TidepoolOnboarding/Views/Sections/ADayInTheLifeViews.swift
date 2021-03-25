//
//  ADayInTheLifeViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct ADayInTheLifeNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .aDayInTheLife, destination: NavigationView { ADayInTheLifeView1() })
            .accessibilityIdentifier("button_a_day_in_the_life")
    }
}

fileprivate struct ADayInTheLifeView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .aDayInTheLife, backButtonHidden: true) {
            EmptyView()
        }
    }
}

