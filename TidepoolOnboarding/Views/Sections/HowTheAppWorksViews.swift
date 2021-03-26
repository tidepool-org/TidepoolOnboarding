//
//  HowTheAppWorksViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct HowTheAppWorksNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .howTheAppWorks, destination: NavigationView { HowTheAppWorksView1() })
            .accessibilityIdentifier("button_how_the_app_works")
    }
}

fileprivate struct HowTheAppWorksView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .howTheAppWorks, backButtonHidden: true) {
            EmptyView()
        }
    }
}
