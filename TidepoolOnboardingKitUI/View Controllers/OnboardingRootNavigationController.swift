//
//  OnboardingRootNavigationController.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Combine
import HealthKit
import SwiftUI
import LoopKit
import LoopKitUI

class OnboardingRootNavigationController: UINavigationController, OnboardingViewController {
    weak var completionDelegate: CompletionDelegate?

    var cgmManagerCreateDelegate: CGMManagerCreateDelegate? {
        get { onboardingViewModel.cgmManagerCreateDelegate }
        set { onboardingViewModel.cgmManagerCreateDelegate = newValue }
    }
    var cgmManagerOnboardDelegate: CGMManagerOnboardDelegate? {
        get { onboardingViewModel.cgmManagerOnboardDelegate }
        set { onboardingViewModel.cgmManagerOnboardDelegate = newValue }
    }
    var pumpManagerCreateDelegate: PumpManagerCreateDelegate? {
        get { onboardingViewModel.pumpManagerCreateDelegate }
        set { onboardingViewModel.pumpManagerCreateDelegate = newValue }
    }
    var pumpManagerOnboardDelegate: PumpManagerOnboardDelegate? {
        get { onboardingViewModel.pumpManagerOnboardDelegate }
        set { onboardingViewModel.pumpManagerOnboardDelegate = newValue }
    }
    var serviceCreateDelegate: ServiceCreateDelegate? {
        get { onboardingViewModel.serviceCreateDelegate }
        set { onboardingViewModel.serviceCreateDelegate = newValue }
    }
    var serviceOnboardDelegate: ServiceOnboardDelegate? {
        get { onboardingViewModel.serviceOnboardDelegate }
        set { onboardingViewModel.serviceOnboardDelegate = newValue }
    }

    private let onboardingViewModel: OnboardingViewModel
    private let displayGlucoseUnitObservable: DisplayGlucoseUnitObservable
    private let colorPalette: LoopUIColorPalette

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboardingUI, onboardingProvider: OnboardingProvider, displayGlucoseUnitObservable: DisplayGlucoseUnitObservable, colorPalette: LoopUIColorPalette) {
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
            .first { $0.hasCompletedSection(.welcome) }
            .sink { [weak self] _ in
                self?.setRootView(GettingToKnowTidepoolLoopView())
            }
            .store(in: &cancellables)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewControllers.isEmpty {
            setRootView(WelcomeTabView())
        }
    }

    private func setRootView<Content: View>(_ rootView: Content) {
        let rootView = rootView
            .environmentObject(onboardingViewModel)
            .environmentObject(displayGlucoseUnitObservable)
            .environment(\.colorPalette, colorPalette)
            .navigationBarHidden(true)
        setViewControllers([UIHostingController(rootView: rootView)], animated: true)
    }
}
