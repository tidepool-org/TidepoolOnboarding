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
        OnboardingSectionNavigationButton(section: .introduction, destination: NavigationView { IntroductionView1() })
            .accessibilityIdentifier("button_introduction")
    }
}

fileprivate struct IntroductionView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .introduction, backButtonHidden: true) {
            EmptyView()
        }
    }
}
