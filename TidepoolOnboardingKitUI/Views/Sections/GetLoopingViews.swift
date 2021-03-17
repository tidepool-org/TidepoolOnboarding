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
        OnboardingSectionNavigationButton(section: .getLooping, destination: GetLoopingNavigationView())
            .accessibilityIdentifier("button_get_looping")
    }
}

fileprivate struct GetLoopingNavigationView: View {
    var body: some View {
        NavigationView() {
            OnboardingSectionPagesView(sectionPages: getLoopingSectionPages)
        }
    }
}

fileprivate let getLoopingSectionPages = OnboardingSectionPages(section: .getLooping, pages: getLoopingPages)
fileprivate let getLoopingPages = [OnboardingPage(title: "Get Looping", view: EmptyView())]
