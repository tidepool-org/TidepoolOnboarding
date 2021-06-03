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

    var body: some View {
        OnboardingSectionNavigationButton(section: .yourDevices, destination: NavigationView { destination })
            .accessibilityIdentifier("button_your_devices")
    }

    @ViewBuilder
    private var destination: some View {
        if onboardingViewModel.notificationAuthorization == nil || onboardingViewModel.notificationAuthorization == .notDetermined {
            YourDevicesNotificationsView()
        } else if !onboardingViewModel.isCGMManagerOnboarded || !onboardingViewModel.isPumpManagerOnboarded {
            YourDevicesPairingYourDevicesView()
        }
    }
}

// MARK: - YourDevicesNotificationsView

fileprivate struct YourDevicesNotificationsView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, destination: YourDevicesPairingYourDevicesView()) {
            PageHeader(title: LocalizedString("Notifications", comment: "Onboarding, Your Devices section, Notifications view, title"))
            Paragraph(LocalizedString("To allow your CGM, pump, and Tidepool Loop app to alert you with important safety and maintenance notifications, you’ll next need to:", comment: "Onboarding, Your Devices section, Notifications view, paragraph 1"))
            NumberedBodyTextList(
                LocalizedString("Enable Notifications in your iPhone or iPod Touch Settings", comment: "Onboarding, Your Devices section, Notifications view, list 1, item 1")
            )
            .padding(.vertical)
            Paragraph(LocalizedString("Notifications may be configured for each component you pair, and can alert you to rising and falling glucose, insulin pump maintenance tasks, or other situations where the app may need your attention.", comment: "Onboarding, Your Devices section, Notifications view, paragraph 2"))
            NumberedBodyTextList(
                LocalizedString("Enable Critical Alerts in your iPhone or iPod Touch Settings", comment: "Onboarding, Your Devices section, Notifications view, list 2, item 1")
            )
            .startingAt(2)
            .padding(.vertical)
            Paragraph(LocalizedString("Critical Alerts may be configured to alert you to higher risk situations while using Tidepool Loop, such as urgent low glucose, insulin pump occlusions, or other serious system errors.", comment: "Onboarding, Your Devices section, Notifications view, paragraph 3"))
        }
        .backButtonHidden(true)
        .nextButtonAction(nextButtonAction)
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        onboardingViewModel.onboardingProvider.authorizeNotification { authorization in
            DispatchQueue.main.async {
                onboardingViewModel.notificationAuthorization = authorization
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

    @State private var isCGMManagerOnboarded = false
    @State private var cgmManagerViewController: CGMManagerViewController?
    @State private var isPumpManagerOnboarded = false
    @State private var pumpManagerViewController: PumpManagerViewController?
    @State private var isSheetPresented = false
    @State private var onSheetDismiss: (() -> Void)?

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices) {
            PageHeader(title: LocalizedString("Pairing Your Devices", comment: "Onboarding, Your Devices section, Pairing Your Devices view, title"))
            Paragraph(LocalizedString("Use your product instructions along with this app to help you pair your devices.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 1"))
            Paragraph(LocalizedString("Before pairing your devices, make sure your smart device, on which you are reading this screen, is connected to the internet.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 2"))
            Paragraph(LocalizedString("You must have both CGM and Pump with you to proceed.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 3"))
                .bold()
            Paragraph(LocalizedString("If you do not yet have both devices, you should wait until you do to proceed.", comment: "Onboarding, Your Devices section, Pairing Your Devices view, paragraph 4"))
            VStack(alignment: .leading, spacing: 30) {
                DeviceView(number: 1, attributed: cgmManagerText, checked: isCGMManagerOnboarded)
                DeviceView(number: 2, attributed: pumpManagerText, checked: isPumpManagerOnboarded)
            }
            .padding(.vertical)
        }
        .backButtonHidden(true)
        .nextButtonTitle(nextButtonTitle)
        .nextButtonAction(nextButtonAction)
        .alert(isPresented: $isAlertPresented) { alert }
        .sheet(isPresented: $isSheetPresented, onDismiss: onSheetDismiss) { sheet }
        .onAppear {
            isCGMManagerOnboarded = onboardingViewModel.isCGMManagerOnboarded
            isPumpManagerOnboarded = onboardingViewModel.isPumpManagerOnboarded
        }
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
        if !isCGMManagerOnboarded {
            return LocalizedString("Pair CGM", comment: "Onboarding, Your Devices section, Pairing Your Devices view, pair CGM button, title")
        } else {
            return LocalizedString("Pair Pump", comment: "Onboarding, Your Devices section, Pairing Your Devices view, pair pump button, title")
        }
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        if !isCGMManagerOnboarded {
            onboardCGMManager(completion)
        } else if !isPumpManagerOnboarded {
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
                self.isSheetPresented = true
                self.onSheetDismiss = { onboardCGMManagerComplete(completion) }
            case .createdAndOnboarded:
                onboardCGMManagerComplete(completion)
            }
        }
    }

    private func onboardCGMManagerComplete(_ completion: @escaping (Bool) -> Void) {
        isCGMManagerOnboarded = onboardingViewModel.isCGMManagerOnboarded
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
                self.isSheetPresented = true
                self.onSheetDismiss = { onboardPumpManagerComplete(completion) }
            case .createdAndOnboarded:
                onboardPumpManagerComplete(completion)
            }
        }
    }

    private func onboardPumpManagerComplete(_ completion: @escaping (Bool) -> Void) {
        isPumpManagerOnboarded = onboardingViewModel.isPumpManagerOnboarded
        completion(isCGMManagerOnboarded && isPumpManagerOnboarded)
    }

    private var alert: Alert {
        Alert(title: Text(LocalizedString("Error", comment: "Title of general error alert")), message: Text(alertMessage!))
    }

    private var sheet: some View {
        managerView
            .presentation(isModal: true)
            .environment(\.dismiss, { isSheetPresented = false })
    }

    @ViewBuilder
    private var managerView: some View {
        if !isCGMManagerOnboarded {
            CGMManagerView(cgmManagerViewController!)
        } else {
            PumpManagerView(pumpManagerViewController!)
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
