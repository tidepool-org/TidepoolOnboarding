//
//  OnboardingRootNavigationController.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Combine
import HealthKit
import SwiftUI
import LoopKit
import LoopKitUI

class OnboardingRootNavigationController: UINavigationController, CGMManagerOnboarding, PumpManagerOnboarding, ServiceOnboarding, CompletionNotifying {
    private enum State {
        case welcome
        case gettingToKnowTidepoolLoop
    }

    var cgmManagerOnboardingDelegate: CGMManagerOnboardingDelegate? {
        get { onboardingViewModel.cgmManagerOnboardingDelegate }
        set { onboardingViewModel.cgmManagerOnboardingDelegate = newValue }
    }
    var pumpManagerOnboardingDelegate: PumpManagerOnboardingDelegate? {
        get { onboardingViewModel.pumpManagerOnboardingDelegate }
        set { onboardingViewModel.pumpManagerOnboardingDelegate = newValue }
    }
    var serviceOnboardingDelegate: ServiceOnboardingDelegate? {
        get { onboardingViewModel.serviceOnboardingDelegate }
        set { onboardingViewModel.serviceOnboardingDelegate = newValue }
    }
    weak var completionDelegate: CompletionDelegate?

    private let onboardingViewModel: OnboardingViewModel
    private let displayGlucoseUnitObservable: DisplayGlucoseUnitObservable
    private let colorPalette: LoopUIColorPalette

    private var state: State?

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboarding, onboardingProvider: OnboardingProvider, displayGlucoseUnitObservable: DisplayGlucoseUnitObservable, colorPalette: LoopUIColorPalette) {
        self.onboardingViewModel = OnboardingViewModel(onboarding: onboarding, onboardingProvider: onboardingProvider)
        self.displayGlucoseUnitObservable = displayGlucoseUnitObservable
        self.colorPalette = colorPalette

        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: UIToolbar.self)

        onboarding.$isOnboarded
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.completionDelegate?.completionNotifyingDidComplete(self)
            }
            .store(in: &cancellables)
        onboardingViewModel.$sectionProgression
            .sink { [weak self] sectionProgression in
                guard let self = self else { return }
                if !sectionProgression.hasCompletedSection(.welcome) {
                    self.setState(.welcome, reset: !sectionProgression.isStarted)
                } else {
                    self.setState(.gettingToKnowTidepoolLoop)
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        onboardingViewModel.updateLastAccessedDate()

        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForegroundNotificationReceived(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackgroundNotificationReceived(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    private func setState(_ state: State, reset: Bool = false) {
        guard state != self.state || reset else {
            return
        }

        switch state {
        case .welcome:
            setRootView(WelcomeTabView(), animated: false)
        case .gettingToKnowTidepoolLoop:
            setRootView(GettingToKnowTidepoolLoopView())
        }

        self.state = state
    }

    private func setRootView<Content: View>(_ rootView: Content, animated: Bool = true) {
        topViewController?.dismiss(animated: animated)  // Dismiss any section modal displayed above Getting to Know Tidepool Loop

        let rootView = rootView
            .environmentObject(onboardingViewModel)
            .environmentObject(displayGlucoseUnitObservable)
            .environment(\.colorPalette, colorPalette)
            .navigationBarHidden(true)
        setViewControllers([UIHostingController(rootView: rootView)], animated: animated)
    }

    @objc private func willEnterForegroundNotificationReceived(_ notification: Notification) {
        onboardingViewModel.updateLastAccessedDate()
    }

    @objc private func didEnterBackgroundNotificationReceived(_ notification: Notification) {
        onboardingViewModel.updateLastAccessedDate()
    }
}
