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
                LocalizedString("Enable Notifications in your iPhone or iPod touch Settings", comment: "Onboarding, Your Devices section, Notifications view, segment 1, list 1, item 1")
            )
            .padding(.vertical)
            Paragraph(LocalizedString("Notifications may be configured for each device you pair and can alert you to rising and falling glucose, insulin pump maintenance tasks, or other situations where the app may need your attention.", comment: "Onboarding, Your Devices section, Notifications view, segment 1, paragraph 1"))
            Paragraph(LocalizedString("To avoid delay in receiving notifications from Tidepool Loop, we recommend notification delivery be set to Immediate Delivery.", comment: "Onboarding, Your Devices section, Notifications view, segment 1, paragraph 2"))
        }
    }

    private var segment2: some View {
        Segment {
            NumberedBodyTextList(
                LocalizedString("Enable Critical Alerts in your iPhone or iPod touch Settings", comment: "Onboarding, Your Devices section, Notifications view, segment 2, list 1, item 1")
            )
            .startingAt(2)
            .padding(.vertical)
            Paragraph(LocalizedString("Critical Alerts may be configured to alert you to higher risk situations while using Tidepool Loop such as urgent low glucose, insulin pump occlusions, or other serious system errors.", comment: "Onboarding, Your Devices section, Notifications view, segment 2, paragraph 1"))
        }
    }

    private var segment3: some View {
        Segment {
            NumberedBodyTextList(
                LocalizedString("Ensure Time Sensitive Notifications are turned on in your iPhone or iPod touch Settings", comment: "Onboarding, Your Devices section, Notifications view, segment 3, list 1, item 1")
            )
            .startingAt(3)
            .padding(.vertical)
            Callout(title: LocalizedString("These permissions must be allowed to continue using the app", comment: "Onboarding, Your Devices section, Notifications view, segment 3, callout title"), warningIconColor: .red) {
                Paragraph(LocalizedString("It is important that you always keep Notifications, Critical Alerts, and Time Sensitive Notifications turned ON in your phone’s settings to ensure that you receive Tidepool Loop notifications.", comment: "Onboarding, Your Devices section, Notifications view, segment 3, callout body text"))
            }
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
            Paragraph(LocalizedString("You must allow Critical Alerts, Notifications, and Time Sensitive Notifications on your smart device to continue using Tidepool Loop.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, paragraph"))
            NumberedBodyTextList(
                LocalizedString("Tap the button below to open Tidepool Loop settings.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 1"),
                LocalizedString("Tap Notifications.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 2"),
                LocalizedString("Allow Critical Alerts, Notifications, and Time Sensitive Notifications.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 3"),
                LocalizedString("Return to this app to continue.", comment: "Onboarding, Your Devices section, Alert Permissions Required view, list, item 4")
            )
            if !criticalAlertAllowed {
                Callout(title: LocalizedString("Critical Alerts must be allowed to continue using the app", comment: "Onboarding, Your Devices section, Alert Permissions Required view, callout 1, title"), warningIconColor: .red)
            }
            if !notificationAllowed {
                Callout(title: LocalizedString("Notifications must be allowed to continue using the app", comment: "Onboarding, Your Devices section, Alert Permissions Required view, callout 2, title"), warningIconColor: .red)
            }
            if notificationAllowed && !timeSensitiveNotificationAllowed {
                Callout(title: LocalizedString("Time Sensitive Notifications must be allowed to continue using the app", comment: "Onboarding, Your Devices section, Alert Permissions Required view, callout 3, title"), warningIconColor: .red)
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
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesAppleHealthView()) {
            PageHeader(title: LocalizedString("Warning: iOS 15 Focus Modes", comment: "Onboarding, Your Devices section, Focus Modes view, title"))
            Paragraph(LocalizedString("iOS 15 has added features such as “Focus Mode” that enable you to have more control over when apps can send you notifications.", comment: "Onboarding, Your Devices section, Focus Modes view, paragraph 1"))
            Paragraph(LocalizedString("If you wish to continue receiving important notifications from Tidepool Loop while in a Focus Mode, you must add Tidepool Loop as an “Allowed App” for each Focus Mode.", comment: "Onboarding, Your Devices section, Focus Modes view, paragraph 2"))
            PresentableImage("YourDevices_FocusModes")
            Segment(header: LocalizedString("How to Add Tidepool Loop as an Allowed App", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, header")) {
                Callout(title: LocalizedString("Note: You’ll need to complete the steps below for each Focus Mode you have enabled or plan to enable.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, callout, title"))
                NumberedBodyTextList(
                    LocalizedString("Go to Settings > Focus.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 1"),
                    LocalizedString("Tap a provided Focus option — like Do Not Disturb, Personal, or Sleep.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 2"),
                    LocalizedString("Under Allowed Notifications, tap “Apps”.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 3"),
                    LocalizedString("Tap “Add App” and add Tidepool Loop.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 4"),
                    LocalizedString("Ensure that “Time Sensitive” is toggled ON.", comment: "Onboarding, Your Devices section, Focus Modes view, segment 1, list, item 5")
                )
            }
        }
        .backButtonHidden(true)
    }
}

// MARK: - YourDevicesAppleHealthView

fileprivate struct YourDevicesAppleHealthView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesPairingYourDevicesView()) {
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

// MARK: - YourDevicesPairingYourDevicesView

fileprivate struct YourDevicesPairingYourDevicesView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var alertMessage: String?
    @State private var isAlertPresented = false

    @State private var cgmManagerViewController: CGMManagerViewController?
    @State private var pumpManagerViewController: PumpManagerViewController?
    @State private var isCGMManagerSheetPresented = false
    @State private var isPumpManagerSheetPresented = false
    @State private var isPauseOnboardingSheetPresented = false
    @State private var onSheetDismiss: (() -> Void)?

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices) {
            PageHeader(title: LocalizedString("Pairing Your Devices", comment: "Onboarding, Your Devices section, Pairing Your Devices view, title"))
            Paragraph(LocalizedString("Use your product instructions along with this app to help you pair your devices.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 1"))
            Paragraph(LocalizedString("Before pairing your devices, make sure your smart device, on which you are reading this screen, is connected to the internet.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 2"))
            Paragraph(LocalizedString("You must have both CGM and Pump with you to proceed.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 3"))
                .bold()
            VStack(alignment: .leading, spacing: 30) {
                DeviceView(number: 1, attributed: cgmManagerText, checked: onboardingViewModel.isCGMManagerOnboarded)
                    .sheet(isPresented: $isCGMManagerSheetPresented, onDismiss: onSheetDismiss) { onboardCGMManagerSheet }
                DeviceView(number: 2, attributed: pumpManagerText, checked: onboardingViewModel.isPumpManagerOnboarded)
                    .sheet(isPresented: $isPumpManagerSheetPresented, onDismiss: onSheetDismiss) { onboardPumpManagerSheet }
            }
            .padding(.vertical)
            Paragraph(LocalizedString("If you do not yet have both devices, or you need to stop for any reason, you can pause and return to this point later.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 4"))
        }
        .backButtonHidden(true)
        .nextButtonTitle(nextButtonTitle)
        .nextButtonAction(nextButtonAction)
        .footer(footer)
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
        switch onboardingViewModel.onboardCGMManager() {
        case .failure(let error):
            self.alertMessage = error.localizedDescription
            self.isAlertPresented = true
        case .success(let success):
            switch success {
            case .userInteractionRequired(let viewController):
                self.cgmManagerViewController = viewController
                self.onSheetDismiss = { onboardCGMManagerComplete(completion) }
                self.isCGMManagerSheetPresented = true
            case .createdAndOnboarded:
                onboardCGMManagerComplete(completion)
            }
        }
    }

    private var onboardCGMManagerSheet: some View {
        CGMManagerView(cgmManagerViewController!)
            .presentation(isModal: true)
            .environment(\.dismissAction, { isCGMManagerSheetPresented = false })
    }

    private func onboardCGMManagerComplete(_ completion: @escaping (Bool) -> Void) {
        completion(false)
    }

    private func onboardPumpManager(_ completion: @escaping (Bool) -> Void) {
        switch onboardingViewModel.onboardPumpManager() {
        case .failure(let error):
            self.alertMessage = error.localizedDescription
            self.isAlertPresented = true
        case .success(let success):
            switch success {
            case .userInteractionRequired(let viewController):
                self.pumpManagerViewController = viewController
                self.onSheetDismiss = { onboardPumpManagerComplete(completion) }
                self.isPumpManagerSheetPresented = true
            case .createdAndOnboarded:
                onboardPumpManagerComplete(completion)
            }
        }
    }

    private var onboardPumpManagerSheet: some View {
        PumpManagerView(pumpManagerViewController!)
            .presentation(isModal: true)
            .environment(\.dismissAction, { isPumpManagerSheetPresented = false })
    }

    private func onboardPumpManagerComplete(_ completion: @escaping (Bool) -> Void) {
        completion(onboardingViewModel.isCGMManagerOnboarded && onboardingViewModel.isPumpManagerOnboarded)
    }

    private var footer: AnyView? {
        if onboardingViewModel.isCGMManagerOnboarded {
            return AnyView(pausingOnboardingButton.padding(.bottom))
        } else {
            return nil
        }
    }

    private var pausingOnboardingButton: some View {
        HStack {
            Spacer()
            Button(action: { isPauseOnboardingSheetPresented = true }) {
                Text(LocalizedString("Pause Onboarding", comment: "Onboarding, Your Devices section, Pairing Your Devices view, button, pause onboarding"))
                    .bold()
            }
            Spacer()
        }
        .sheet(isPresented: $isPauseOnboardingSheetPresented) { pauseOnboardingSheet }
    }

    private var pauseOnboardingSheet: some View {
        NavigationView {
            YourDevicesPauseOnboardingView()
                .environmentObject(onboardingViewModel)
                .environment(\.dismissAction, { isPauseOnboardingSheetPresented = false })
        }
        .presentation(isModal: true)
    }

    private var alert: Alert {
        Alert(title: Text(LocalizedString("Error", comment: "Title of general error alert")), message: Text(alertMessage!))
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

fileprivate struct YourDevicesPauseOnboardingView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.dismissAction) var dismiss

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 10) {
                        Segment {
                            PageHeader(title: LocalizedString("Pause Onboarding", comment: "Onboarding, Your Devices section, Pause Onboarding view, title"))
                            PresentableImage("YourDevices_PauseOnboarding")
                            Paragraph(LocalizedString("You can use any of the Close buttons to exit out of onboarding screens or tap Pause Onboarding and return to this point later.", comment: "Onboarding, Your Devices section, Pause Onboarding view, paragraph 1"))
                            Paragraph(LocalizedString("Later, when you are ready to continue, tap “Complete Setup” to return to this part of the onboarding.", comment: "Onboarding, Your Devices section, Pause Onboarding view, paragraph 2"))
                        }
                        Spacer()
                        nextButton
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: closeButton)
    }

    private var closeButton: some View {
        Button(action: closeButtonAction) {
            Text(LocalizedString("Close", comment: "Onboarding, Your Devices section, Pause Onboarding view, button, close"))
                .fontWeight(.regular)
        }
    }

    private func closeButtonAction() {
        dismiss()
    }

    private var nextButton: some View {
        ActionButton(title: LocalizedString("Pause Onboarding", comment: "Onboarding, Your Devices section, Pause Onboarding view, button, pause onboarding"), action: nextButtonAction)
    }

    private func nextButtonAction() {
        onboardingViewModel.isSuspended = true
        dismiss()
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
