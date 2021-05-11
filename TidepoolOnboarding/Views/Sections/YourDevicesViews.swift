//
//  YourDevicesViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct YourDevicesNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .yourDevices, destination: NavigationViewWithNavigationBarAppearance { YourDevicesViewNotifications() })
            .accessibilityIdentifier("button_your_devices")
    }
}

fileprivate struct YourDevicesViewNotifications: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices) {
            PageHeader(title: LocalizedString("Notifications", comment: "Onboarding, Your Devices section, notifications, title"))
            Paragraph(LocalizedString("To allow your CGM, pump, and Tidepool Loop app to alert you with important safety and maintenance notifications, you’ll next need to:", comment: "Onboarding, Your Devices section, notifications, paragraph 1"))
            NumberedBodyTextList(
                LocalizedString("Enable Notifications in your iPhone or iPod Touch Settings", comment: "Onboarding, Your Devices section, notifications, list 1, item 1")
            )
            .padding(.vertical)
            Paragraph(LocalizedString("Notifications may be configured for each component you pair, and can alert you to rising and falling glucose, insulin pump maintenance tasks, or other situations where the app may need your attention.", comment: "Onboarding, Your Devices section, notifications, paragraph 2"))
            NumberedBodyTextList(
                LocalizedString("Enable Critical Alerts in your iPhone or iPod Touch Settings", comment: "Onboarding, Your Devices section, notifications, list 2, item 1")
            )
            .startingAt(2)
            .padding(.vertical)
            Paragraph(LocalizedString("Critical Alerts may be configured to alert you to higher risk situations while using Tidepool Loop, such as urgent low glucose, insulin pump occlusions, or other serious system errors.", comment: "Onboarding, Your Devices section, notifications, paragraph 3"))
        }
        .backButtonHidden(true)
        .nextButtonAction(nextButtonAction)
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        onboardingViewModel.onboardingProvider.authorizeNotification { authorization in
            completion(authorization != .notDetermined)
        }
    }
}

struct YourDevicesViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.yourDevices)
        return onboardingViewModel
    }()

    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()

    static var previews: some View {
        ContentPreviewWithBackground {
            YourDevicesNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
