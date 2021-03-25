//
//  YourSettingsViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct YourSettingsNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .yourSettings, destination: YourSettingsNavigationView())
            .accessibilityIdentifier("button_your_settings")
    }
}

fileprivate typealias YourSettingsNavigationView = PrescriptionReviewView
