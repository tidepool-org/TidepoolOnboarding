//
//  OnboardingWelcomeTabView.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct OnboardingWelcomeTabView: View {
    var body: some View {
        OnboardingTabView(tabs: onboardingWelcomeViews)
    }
}

struct OnboardingWelcomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreview {
            OnboardingWelcomeTabView()
        }
    }
}
