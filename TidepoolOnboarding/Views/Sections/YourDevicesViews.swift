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
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var notificationAuthorized = false
    @State private var criticalAlertAllowed = false
    @State private var notificationAllowed = false
    @State private var timeSensitiveNotificationAllowed = false
    @State private var healthStoreAuthorized = false
    @State private var isCGMManagerOnboarded = false
    @State private var isPumpManagerOnboarded = false

    var body: some View {
        OnboardingSectionNavigationButton(section: .yourDevices, destination: NavigationView { destination }, action: action)
            .accessibilityIdentifier("button_your_devices")
    }

    @ViewBuilder
    private var destination: some View {
        if !notificationAuthorized {
            YourDevicesNotificationsView()
        } else if !criticalAlertAllowed || !notificationAllowed || !timeSensitiveNotificationAllowed {
            YourDevicesAlertPermissionsRequiredView(criticalAlertAllowed: criticalAlertAllowed, notificationAllowed: notificationAllowed, timeSensitiveNotificationAllowed: timeSensitiveNotificationAllowed)
        } else if !healthStoreAuthorized {
            YourDevicesFocusModesView()
        } else if !isCGMManagerOnboarded || !isPumpManagerOnboarded {
            YourDevicesPairingYourDevicesView()
        }
    }

    private func action() -> Bool {
        self.notificationAuthorized = onboardingViewModel.notificationAuthorization != nil && onboardingViewModel.notificationAuthorization != .notDetermined
        self.criticalAlertAllowed = onboardingViewModel.criticalAlertAllowed ?? false
        self.notificationAllowed = onboardingViewModel.notificationAllowed ?? false
        self.timeSensitiveNotificationAllowed = onboardingViewModel.timeSensitiveNotificationAllowed ?? false
        self.healthStoreAuthorized = onboardingViewModel.healthStoreAuthorization != nil && onboardingViewModel.healthStoreAuthorization != .notDetermined
        self.isCGMManagerOnboarded = onboardingViewModel.isCGMManagerOnboarded
        self.isPumpManagerOnboarded = onboardingViewModel.isPumpManagerOnboarded
        return true
    }
}

// MARK: - YourDevicesNotificationsView

fileprivate struct YourDevicesNotificationsView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var criticalAlertAllowed = false
    @State private var notificationAllowed = false
    @State private var timeSensitiveNotificationAllowed = false

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: destination) {
            PageHeader(title: LocalizedString("Notifications", comment: "Onboarding, Your Devices section, Notifications view, title"))
            PresentableImage("YourDevices_Notifications")
            Paragraph(LocalizedString("To allow your CGM, pump, and Tidepool Loop app to alert you with important safety and maintenance notifications, you’ll next need to:", comment: "Onboarding, Your Devices section, Notifications view, paragraph 1"))
            segment1
            segment2
            segment3
            Paragraph(LocalizedString("Additional preferences can be set within the device manager screens of the Tidepool Loop app.", comment: "Onboarding, Your Devices section, Notifications view, paragraph 2"))
                .padding(.top)
        }
        .backButtonHidden(true)
        .nextButtonAction(nextButtonAction)
    }

    private var segment1: some View {
        Segment {
            NumberedBodyTextList(
                LocalizedString("Enable Notifications in your iPhone or iPod touch Settings.", comment: "Onboarding, Your Devices section, Notifications view, segment 1, list 1, item 1")
            )
            .padding(.vertical)
            Paragraph(LocalizedString("Notifications may be configured for each device you pair and can alert you to rising and falling glucose, insulin pump maintenance tasks, or other situations where the app may need your attention.", comment: "Onboarding, Your Devices section, Notifications view, segment 1, paragraph 1"))
            Paragraph(LocalizedString("To avoid delay in receiving notifications from Tidepool Loop, we recommend notification delivery be set to Immediate Delivery.", comment: "Onboarding, Your Devices section, Notifications view, segment 1, paragraph 2"))
        }
    }

    private var segment2: some View {
        Segment {
            NumberedBodyTextList(
                LocalizedString("Enable Critical Alerts in your iPhone or iPod touch Settings.", comment: "Onboarding, Your Devices section, Notifications view, segment 2, list 1, item 1")
            )
            .startingAt(2)
            .padding(.vertical)
            Paragraph(LocalizedString("Critical Alerts may be configured to alert you to higher risk situations while using Tidepool Loop such as urgent low glucose, insulin pump occlusions, or other serious system errors.", comment: "Onboarding, Your Devices section, Notifications view, segment 2, paragraph 1"))
        }
    }

    private var segment3: some View {
        Segment {
            NumberedBodyTextList(
                LocalizedString("Ensure Time Sensitive Notifications are turned on in your iPhone or iPod touch Settings.", comment: "Onboarding, Your Devices section, Notifications view, segment 3, list 1, item 1")
            )
            .startingAt(3)
            .padding(.vertical)
            
            Callout(
                .warning,
                title: Text("These permissions must be allowed to continue using the app", comment: "Onboarding, Your Devices section, Notifications view, segment 3, callout title"),
                message: Text("It is important that you always keep Notifications, Critical Alerts, and Time Sensitive Notifications turned ON in your phone’s settings to ensure that you receive Tidepool Loop notifications.", comment: "Onboarding, Your Devices section, Notifications view, segment 3, callout body text")
            )
            .padding(.horizontal, -16)
        }
    }

    @ViewBuilder
    private var destination: some View {
        if !criticalAlertAllowed || !notificationAllowed || !timeSensitiveNotificationAllowed {
            YourDevicesAlertPermissionsRequiredView(criticalAlertAllowed: criticalAlertAllowed, notificationAllowed: notificationAllowed, timeSensitiveNotificationAllowed: timeSensitiveNotificationAllowed)
        } else {
            YourDevicesFocusModesView()
        }
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        onboardingViewModel.onboardingProvider.authorizeNotification { authorization in
            onboardingViewModel.updateNotificationSettings {
                onboardingViewModel.notificationAuthorization = authorization
                self.criticalAlertAllowed = onboardingViewModel.criticalAlertAllowed ?? false
                self.notificationAllowed = onboardingViewModel.notificationAllowed ?? false
                self.timeSensitiveNotificationAllowed = onboardingViewModel.timeSensitiveNotificationAllowed ?? false
                completion(authorization != .notDetermined)
            }
        }
    }
}

// MARK: - YourDevicesAlertPermissionsRequiredView

fileprivate struct YourDevicesAlertPermissionsRequiredView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State var criticalAlertAllowed: Bool
    @State var notificationAllowed: Bool
    @State var timeSensitiveNotificationAllowed: Bool

    @State private var isDestinationActive = false

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesFocusModesView(), isDestinationActive: $isDestinationActive) {
            PageHeader(title: LocalizedString("Alert Permissions Required", comment: "Onboarding, Your Devices section, Alert Permissions Required view, title"))
            PresentableImage("YourDevices_AlertPermissionsRequired")
            Paragraph(LocalizedString("You must allow Notifications, Critical Alerts, and Time Sensitive Notifications on your smart device to continue using Tidepool Loop.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, paragraph"))
            NumberedBodyTextList(
                LocalizedString("Tap the button below to open Tidepool Loop settings.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 1"),
                LocalizedString("Tap Notifications.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 2"),
                LocalizedString("Allow Notifications, Critical Alerts, and Time Sensitive Notifications.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 3"),
                LocalizedString("Return to this app to continue.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 4")
            )
            if !notificationAllowed {
                
                Callout(
                    .warning,
                    title: Text(
                        "Notifications must be allowed to continue using the app",
                        comment: "Onboarding, Your Devices section, Alert Permissions Required view, callout 2, title"
                    )
                )
                .padding(.horizontal, -16)
            }
            if !criticalAlertAllowed {
                Callout(
                    .warning,
                    title: Text(
                        "Critical Alerts must be allowed to continue using the app",
                        comment: "Onboarding, Your Devices section, Alert Permissions Required view, callout 1, title"
                    )
                )
                .padding(.horizontal, -16)
            }
            if notificationAllowed && !timeSensitiveNotificationAllowed {
                Callout(
                    .warning,
                    title: Text(
                        "Time Sensitive Notifications must be allowed to continue using the app",
                        comment: "Onboarding, Your Devices section, Alert Permissions Required view, callout 3, title"
                    )
                )
                .padding(.horizontal, -16)
            }
        }
        .backButtonHidden(true)
        .nextButtonTitle(LocalizedString("Go to Settings", comment: "Onboarding, Your Devices section, Alert Permissions Required view, go to settings button, title"))
        .nextButtonAction(nextButtonAction)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            onboardingViewModel.updateNotificationSettings {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0.5)) {   // Delay to allow time for app switch
                    self.criticalAlertAllowed = onboardingViewModel.criticalAlertAllowed ?? false
                    self.notificationAllowed = onboardingViewModel.notificationAllowed ?? false
                    self.timeSensitiveNotificationAllowed = onboardingViewModel.timeSensitiveNotificationAllowed ?? false
                    self.isDestinationActive = self.criticalAlertAllowed && self.notificationAllowed && self.timeSensitiveNotificationAllowed
                }
            }
        }
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        if let openSettingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(openSettingsURL) {
            UIApplication.shared.open(openSettingsURL)
        }
        completion(false)
    }
}

// MARK: - YourDevicesFocusModesView

fileprivate struct YourDevicesFocusModesView: View {
    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesMuteAppSounds()) {
            PageHeader(title: LocalizedString("iOS 15 Focus Modes", comment: "Onboarding, Your Devices section, Focus Modes view, title"))
            Paragraph(LocalizedString("iOS 15 has added features such as “Focus Mode” that enable you to have more control over when apps can send you notifications.", comment: "Onboarding, Your Devices section, Focus Modes view, paragraph 1"))
            Paragraph(Text("If you wish to continue receiving important notifications from Tidepool Loop while in a Focus Mode, ", comment: "Onboarding, Your Devices section, Focus Modes view, paragraph 2") + Text("you must ensure that notifications are allowed and NOT silenced from Tidepool Loop").bold() + Text(" for each Focus Mode.", comment: "Onboarding, Your Devices section, Focus Modes view, paragraph 2"))
            NumberedBodyTextList(
                LocalizedString("Go to Settings > Focus.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 1"),
                LocalizedString("Tap a provided Focus option — like Do Not Disturb, Personal, or Sleep.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 2"),
                LocalizedString("Tap “Apps”.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 3"),
                LocalizedString("Ensure that notifications are allowed and NOT silenced from Tidepool Loop.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 4")
            )
            PresentableImage("YourDevices_FocusModes_1")
            Paragraph(
                Text("Example: Allow Notifications from Tidepool Loop", comment: "Onboarding, Your Devices section, Focus Modes view, image 1 description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            ).padding(.top, -16)
            PresentableImage("YourDevices_FocusModes_2")
            Paragraph(
                Text("Example: Silence Notifications from other apps", comment: "Onboarding, Your Devices section, Focus Modes view, image 2 description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            ).padding(.top, -16)
            Callout(
                .caution,
                title: Text(
                    "You’ll need to ensure these settings for each Focus Mode you have enabled or plan to enable.",
                    comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, callout, title"
                )
            )
            .padding(.horizontal, -16)
        }
        .backButtonHidden(false)
    }
}

// MARK: - Mute Alerts

fileprivate struct YourDevicesMuteAppSounds: View {
    @Environment(\.guidanceColors) private var guidanceColors

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesAppleHealthView()) {
            PageHeader(title: LocalizedString("Mute App Sounds", comment: "Onboarding, Your Devices section, Mute App Sounds view, title"))
            Paragraph(LocalizedString("Tidepool Loop has its own silencing feature called ‘Mute App Sounds’ that allows you to temporarily silence all sounds from the app.", comment: "Onboarding, Your Devices section, Mute App Sounds view, paragraph 1"))
            Paragraph(LocalizedString("For safety, keep iOS haptics enabled, so that alerts will still vibrate to keep you informed of important safety updates.", comment: "Onboarding, Your Devices section, Mute App Sounds view, paragraph 2"))
            Callout(
                .note,
                title: Text(
                    "Mute App Sounds vs Critical Alerts",
                    comment: "Onboarding, Your Devices section, Mute  App Sounds Modes view, segment 1, callout, title"
                ),
                message: Text(
                    "\nMute App Sounds allows you to mute notifications and Critical Alerts for a specified period of time.\n\nWe recommend using this feature rather than turning off Critical Alerts completely, which would disable important alerts indefinitely.",
                    comment: "Onboarding, Your Devices section, Mute App Sounds Modes view, segment 1, callout, message"
                )
            )
            .padding(.horizontal, -16)
            Segment(header: LocalizedString("Mute App Sounds and Focus Modes", comment: "Onboarding, Your Devices section, Mute App Sounds view, segment 1, header")) {
                Paragraph(LocalizedString("When using Mute App Sounds, also consider the impact of using iOS Focus Modes.", comment: "Onboarding, Your Devices section, Mute App Sounds view, segment 1, paragraph 1"))
                VStack(alignment: .leading, spacing: 10) {
                    HStack() {
                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(guidanceColors.warning)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))

                        Paragraph(LocalizedString("Tidepool Loop App Sounds", comment: "Onboarding, Your Devices section, Mute Alerts view, segment 1, sub-header 1"))
                            .bold()
                    }
                    Paragraph(LocalizedString("All Tidepool Loop notifications, including Critical Alerts, will be silenced for up to 4 hours. Your insulin pump and CGM hardware may still sound. After the mute period ends, your app sounds will resume.", comment: "Onboarding, Your Devices section, Mute Alerts view, segment 1, paragraph 1"))
                        .padding(.vertical)

                    HStack() {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.accentColor)

                        Paragraph(LocalizedString("iOS Focus Mode", comment: "Onboarding, Your Devices section, Mute App Sounds view, segment 1, sub-header 2"))
                            .bold()
                    }
                    Paragraph(LocalizedString("If iOS Focus Mode is ON and Mute App Sounds is OFF, Critical Alerts will still be delivered, but non-Critical Alerts will be silenced.", comment: "Onboarding, Your Devices section, Mute App Sounds view, segment 1, paragraph 3"))
                }
            }
            Segment(header: LocalizedString("How to Mute Sounds", comment: "Onboarding, Your Devices section, Mute Alerts view, segment 2, header")) {
                PresentableImage("YourDevices_MuteSounds")
                NumberedBodyTextList(
                    LocalizedString("Go to Tidepool Loop Settings > Alert Management", comment: "Onboarding, Your Devices section, Mute Alerts view, segment 2, list, item 1"),
                    LocalizedString("Tap Mute App Sounds", comment: "Onboarding, Your Devices section, Mute App Sounds view, segment 2, list, item 2"),
                    LocalizedString("Set mute duration of up to 4 hours", comment: "Onboarding, Your Devices section, Mute App Sounds view, segment 2, list, item 3")
                )
            }
        }
        .backButtonHidden(false)
    }
}

// MARK: - YourDevicesAppleHealthView

fileprivate struct YourDevicesAppleHealthView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesManageAutomaticUpdates()) {
            PageHeader(title: LocalizedString("Apple Health", comment: "Onboarding, Your Devices section, Apple Health view, title"))
            HStack {
                Spacer()
                PresentableImage("YourDevices_AppleHealth_1")
                    .frame(width: 85, height: 85, alignment: .center)
                Spacer()
            }
            Paragraph(LocalizedString("Apple Health can be used to store blood glucose, insulin and carbohydrate data from Tidepool Loop.", comment: "Onboarding, Your Devices section, Apple Health view, paragraph 1"))
            Paragraph(LocalizedString("If you’d like to allow this data to be stored in Apple Health, Turn All Categories On in the following screen.", comment: "Onboarding, Your Devices section, Apple Health view, paragraph 2"))
            Paragraph(LocalizedString("If you prefer not to store this information in Apple Health, you can leave them toggled off and select Don’t Allow.", comment: "Onboarding, Your Devices section, Apple Health view, paragraph 3"))
                .padding(.bottom)
            NumberedBodyTextList(
                LocalizedString("Tap “Turn all Categories On”.", comment: "Onboarding, Your Devices section, Apple Health view, list 1, item 1")
            )
            PresentableImage(decorative: "YourDevices_AppleHealth_2")
            NumberedBodyTextList(
                LocalizedString("Tap “Allow” to grant Tidepool Loop permission.", comment: "Onboarding, Your Devices section, Apple Health view, list 2, item 1")
            )
            .startingAt(2)
            PresentableImage(decorative: "YourDevices_AppleHealth_3")
        }
        .nextButtonTitle(LocalizedString("Share With Apple Health", comment: "Onboarding, Your Devices section, Apple Health view, next button, title"))
        .nextButtonAction(nextButtonAction)
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        onboardingViewModel.onboardingProvider.authorizeHealthStore { authorization in
            DispatchQueue.main.async {
                onboardingViewModel.healthStoreAuthorization = authorization
                completion(authorization != .notDetermined)
            }
        }
    }
}

// MARK: - YourDevicesManageAutomaticUpdates

fileprivate struct YourDevicesManageAutomaticUpdates: View {
    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesRestartingTidepoolLoop()) {
            PageHeader(title: LocalizedString("Manage Automatic Updates", comment: "Onboarding, Your Devices section, Manage Automatic Updates, title"))
            Paragraph(LocalizedString("In the case that your iOS software is updated, your device will restart to successfully complete the update. During the restart, Tidepool Loop will not be able to adjust insulin delivery.", comment: "Onboarding, Your Devices section, Manage Automatic Updates, paragraph 1"))
            Paragraph(LocalizedString("To ensure any updates to your iOS do not happen overnight, you must turn off ‘Automatic Updates’ before using Tidepool Loop.", comment: "Onboarding, Your Devices section, Manage Automatic Updates, paragraph 2"))
            PresentableImage("YourDevices_ManageAutomaticUpdates")
            Segment(header: LocalizedString("How to turn off Automatic Updates", comment: "Onboarding, Your Devices section, Manage Automatic Updates, segment 1, header")) {
                Callout(
                    .note,
                    title: Text(
                        "Managing iOS Updates",
                        comment: "Onboarding, Your Devices section, Manage Automatic Updates, segment 1, callout, title"
                    ),
                    message: Text(
                        "When the device restarts following an iOS update, you will need to manually restart Tidepool Loop",
                        comment: "Onboarding, Your Devices section, Manage Automatic Updates, segment 1, callout, message"
                    )
                )
                .padding(.horizontal, -16)
                NumberedBodyTextList(
                    LocalizedString("Go to Settings > General > Software Updates.", comment: "Onboarding, Your Devices section, Manage Automatic Updates, segment 1, list, item 1"),
                    LocalizedString("Tap Automatic Updates.", comment: "Onboarding, Your Devices section, Manage Auomatic Updates, segment 1, list, item 2"),
                    LocalizedString("Toggle off “Install iOS Updates”", comment: "Onboarding, Your Devices section, Manage Automatic Updates, segment 1, list, item 3")
                )
            }
        }
    }
}

// MARK: - YourDevicesRestartingTidepoolLoop

fileprivate struct YourDevicesRestartingTidepoolLoop: View {
    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesPairingYourDevicesView()) {
            PageHeader(title: LocalizedString("Manually Restarting Tidepool Loop", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, title"))
            PresentableImage("YourDevices_RestartingTidepoolLoop")
            Paragraph(LocalizedString("Under certain circumstances, you must manually restart Tidepool Loop and resume insulin delivery.", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, paragraph 1"))
            Paragraph(LocalizedString("You will need to manually restart Tidepool Loop after the following:", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, paragraph 2"))
            BulletedBodyTextList(
                LocalizedString("Restarting your device", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, list, item 1"),
                LocalizedString("Force quitting the Tidepool Loop app", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, list, item 2"),
                LocalizedString("Tidepool Loop has crashed", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, list, item 3"),
                LocalizedString("iOS updates", comment: "Onboarding, Your Devices section, Restarting Tidepool Loop view, list, item 4")
            )
        }
    }
}

// MARK: - YourDevicesPairingYourDevicesView

fileprivate struct YourDevicesPairingYourDevicesView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var alertMessage: String?
    @State private var alertAction: (() -> Void)?
    @State private var isAlertPresented = false

    @State private var cgmManagerViewController: CGMManagerViewController?
    @State private var pumpManagerViewController: PumpManagerViewController?

    var body: some View {
        OnboardingSectionPageView(
            section: .yourDevices,
            content: {
                PageHeader(title: LocalizedString("Pairing Your Devices", comment: "Onboarding, Your Devices section, Pairing Your Devices view, title"))
                Paragraph(LocalizedString("Use your product instructions along with this app to help you pair your devices.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 1"))
                Callout(
                    .note,
                    title: Text(
                        "Internet Required",
                        comment: "Title of internet required highlight"
                    ),
                    message: Text(
                        "Your phone will need to be connected to the internet to complete pairing.",
                        comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 2"
                    )
                )
                .padding(.horizontal, -16)
                Paragraph(LocalizedString("You must have both CGM and Pump with you to proceed.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 3"))
                    .bold()
                VStack(alignment: .leading, spacing: 30) {
                    DeviceView(number: 1, attributed: cgmManagerText, checked: onboardingViewModel.isCGMManagerOnboarded)
                        // Can't use `.alertOnLongPressGesture` because we already have an .alert below :(
                        .onLongPressGesture(minimumDuration: 2) {
                            if onboardingViewModel.allowDebugFeatures { // NOTE: DEBUG FEATURES - DEBUG AND TEST ONLY
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                alertMessage = "Are you sure you want to skip pairing a CGM and use the CGM simulator?" // Not localized
                                alertAction = onboardingViewModel.skipCompleteYourDevicesCGMManager
                                isAlertPresented = true
                            }
                        }
                    DeviceView(number: 2, attributed: pumpManagerText, checked: onboardingViewModel.isPumpManagerOnboarded)
                        // Can't use `.alertOnLongPressGesture` because we already have an .alert below :(
                        .onLongPressGesture(minimumDuration: 2) {
                            if onboardingViewModel.allowDebugFeatures { // NOTE: DEBUG FEATURES - DEBUG AND TEST ONLY
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                alertMessage = "Are you sure you want to skip pairing a Pump and use the Pump simulator?" // Not localized
                                alertAction = onboardingViewModel.skipCompleteYourDevicesPumpManager
                                isAlertPresented = true
                            }
                        }
                }
                Paragraph(LocalizedString("If you need to stop for any reason, you can tap Pause Onboarding or any of the Close buttons to exit. You may return to this point later by tapping “Complete Setup” on Tidepool Loop’s home screen.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 4"))
            }, 
            footer: footer
        )
        .backButtonHidden(true)
        .nextButtonTitle(nextButtonTitle)
        .nextButtonAction(nextButtonAction)
        .alert(isPresented: $isAlertPresented) { alert }
    }

    private var cgmManagerText: String {
        return String(format: LocalizedString("Pair your Continuous Glucose Monitor (CGM): <b>%1$@</b>", comment: "Onboarding, Your Devices section, Pairing Your Devices view, list, CGM (1: CGM title)"),
                      onboardingViewModel.cgmManagerTitle)
    }

    private var pumpManagerText: String {
        return String(format: LocalizedString("Pair your Pump: <b>%1$@</b>", comment: "Onboarding, Your Devices section, Pairing Your Devices view, list, pump (1: pump title)"),
                      onboardingViewModel.pumpManagerTitle)
    }

    private var nextButtonTitle: String? {
        if !onboardingViewModel.isCGMManagerOnboarded {
            return LocalizedString("Pair CGM", comment: "Onboarding, Your Devices section, Pairing Your Devices view, pair CGM button, title")
        } else {
            return LocalizedString("Pair Pump", comment: "Onboarding, Your Devices section, Pairing Your Devices view, pair pump button, title")
        }
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        if !onboardingViewModel.isCGMManagerOnboarded {
            onboardCGMManager(completion)
        } else if !onboardingViewModel.isPumpManagerOnboarded {
            onboardPumpManager(completion)
        } else {
            completion(true)
        }
    }

    private func onboardCGMManager(_ completion: @escaping (Bool) -> Void) {
        onboardingViewModel.onboardCGMManager({ error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.isAlertPresented = true
            } else {
                completion(hasOnboardedAllDevices)
            }
        })
    }

    private func onboardPumpManager(_ completion: @escaping (Bool) -> Void) {
        onboardingViewModel.onboardPumpManager({ error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.isAlertPresented = true
            } else {
                completion(hasOnboardedAllDevices)
            }
        })
    }
    
    private var hasOnboardedAllDevices: Bool {
        onboardingViewModel.isCGMManagerOnboarded && onboardingViewModel.isPumpManagerOnboarded
    }

    @ViewBuilder
    private var footer: some View {
        if onboardingViewModel.isCGMManagerOnboarded {
            pausingOnboardingButton.padding(.bottom)
        }
    }

    private var pausingOnboardingButton: some View {
        HStack {
            Spacer()
            Button(action: { onboardingViewModel.isSuspended = true }) {
                Text(LocalizedString("Pause Onboarding", comment: "Onboarding, Your Devices section, Pairing Your Devices view, button, pause onboarding"))
                    .bold()
            }
            Spacer()
        }
    }

    private var alert: Alert {
        if let action = alertAction {
            return Alert(title: Text(alertMessage!),
                         primaryButton: .cancel(),
                         secondaryButton: .destructive(Text("Yes"), action: action))
        } else {
            return Alert(title: Text(LocalizedString("Error", comment: "Title of general error alert")), message: Text(alertMessage!))
        }
    }

    fileprivate struct DeviceView: View {
        let number: Int
        let attributed: String
        let checked: Bool

        var body: some View {
            HStack(spacing: 10) {
                NumberCircle(number)
                BodyText(attributed: attributed)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                CheckmarkCircle()
                    .padding(.horizontal)
                    .opacity(checked ? 1.0: 0.0)
            }
        }
    }
}


struct YourDevicesViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.yourDevices)
        return onboardingViewModel
    }()

    static var displayGlucosePreference: DisplayGlucosePreference = {
        return DisplayGlucosePreference.preview
    }()

    static var previews: some View {
        ContentPreviewWithBackground {
            YourDevicesNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucosePreference)
        }
    }
}
