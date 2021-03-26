//
//  YourDevicesViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct YourDevicesNavigationButton: View {
    var body: some View {
        OnboardingSectionNavigationButton(section: .yourDevices, destination: NavigationView { YourDevicesView1() })
            .accessibilityIdentifier("button_your_devices")
    }
}

fileprivate struct YourDevicesView1: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State var authorizeNotificationEnabled = false
    @State var authorizeHealthStoreEnabled = false
    @State var authorizeBluetoothEnabled = false

    var body: some View {
        OnboardingSectionPageView(section: .yourDevices, backButtonHidden: true) {
            VStack {
                Spacer()
                authorizeNotificationButton
                authorizeHealthStoreButton
                authorizeBluetoothButton
                Spacer()
            }
        }
        .onAppear {
            checkAuthorization()
        }
    }

    private var authorizeNotificationButton: some View {
        ActionButton(title: "Authorize Notifications") {
            onboardingViewModel.onboardingProvider.authorizeNotification { authorization in
                DispatchQueue.main.async {
                    self.authorizeNotificationEnabled = authorization == .notDetermined
                }
            }
        }.disabled(!authorizeNotificationEnabled)
    }

    private var authorizeHealthStoreButton: some View {
        ActionButton(title: "Authorize Health Store") {
            onboardingViewModel.onboardingProvider.authorizeHealthStore { authorization in
                DispatchQueue.main.async {
                    self.authorizeHealthStoreEnabled = authorization == .notDetermined
                }
            }
        }.disabled(!authorizeHealthStoreEnabled)
    }

    private var authorizeBluetoothButton: some View {
        ActionButton(title: "Authorize Bluetooth") {
            onboardingViewModel.onboardingProvider.authorizeBluetooth { authorization in
                DispatchQueue.main.async {
                    self.authorizeBluetoothEnabled = authorization == .notDetermined
                }
            }
        }.disabled(!authorizeBluetoothEnabled)
    }

    private func checkAuthorization() {
        self.authorizeBluetoothEnabled = onboardingViewModel.onboardingProvider.bluetoothAuthorization == .notDetermined
        onboardingViewModel.onboardingProvider.getNotificationAuthorization { authorization in
            DispatchQueue.main.async {
                self.authorizeNotificationEnabled = authorization == .notDetermined
            }
        }
        onboardingViewModel.onboardingProvider.getHealthStoreAuthorization { authorization in
            DispatchQueue.main.async {
                self.authorizeHealthStoreEnabled = authorization == .notDetermined
            }
        }
    }
}
