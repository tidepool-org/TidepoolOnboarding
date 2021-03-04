//
//  OnboardingRootViewController.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import HealthKit
import Combine
import SwiftUI
import LoopKit
import LoopKitUI

class OnboardingRootViewController: UIHostingController<AnyView>, OnboardingViewController {
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
    private let preferredGlucoseUnit: PreferredGlucoseUnit

    private lazy var cancellables = Set<AnyCancellable>()

    init(onboarding: TidepoolOnboardingUI, onboardingProvider: OnboardingProvider, preferredGlucoseUnit: HKUnit, colorPalette: LoopUIColorPalette) {
        self.onboardingViewModel = OnboardingViewModel(onboarding: onboarding, onboardingProvider: onboardingProvider)
        self.preferredGlucoseUnit = PreferredGlucoseUnit(preferredGlucoseUnit)

        let rootView = OnboardingRootView()
            .environmentObject(self.onboardingViewModel)
            .environmentObject(self.preferredGlucoseUnit)
            .environment(\.colorPalette, colorPalette)

        super.init(rootView: AnyView(rootView))

        onboarding.$isOnboarded
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.completionDelegate?.completionNotifyingDidComplete(self)
            }
            .store(in: &cancellables)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PreferredGlucoseUnitObserver

    func preferredGlucoseUnitDidChange(to preferredGlucoseUnit: HKUnit) {
        self.preferredGlucoseUnit.preferredGlucoseUnitDidChange(to: preferredGlucoseUnit)
    }
}
