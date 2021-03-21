//
//  GetLoopingViews.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct GetLoopingNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .getLooping, destination: NavigationView { GetLoopingView1() })
            .accessibilityIdentifier("button_get_looping")
    }
}

fileprivate struct GetLoopingView1: View {
    var body: some View {
        OnboardingSectionPageView(section: .getLooping, backButtonHidden: true) {
            EmptyView()
        }
    }
}
