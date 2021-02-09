//
//  OnboardingRootViewController.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import HealthKit
import SwiftUI
import LoopKitUI

class OnboardingRootViewController: UIHostingController<OnboardingRootView>, OnboardingViewController {
    var onboardingDelegate: OnboardingDelegate? {
        get { onboardingViewModel.onboardingDelegate }
        set { onboardingViewModel.onboardingDelegate = newValue }
    }
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
    weak var completionDelegate: CompletionDelegate?

    private let onboardingViewModel: OnboardingViewModel
    private let preferredGlucoseUnitViewModel: PreferredGlucoseUnitViewModel

    init(cgmManagerProvider: CGMManagerProvider, pumpManagerProvider: PumpManagerProvider, serviceProvider: ServiceProvider, preferredGlucoseUnit: HKUnit, colorPalette: LoopUIColorPalette) {
        self.onboardingViewModel = OnboardingViewModel(cgmManagerProvider: cgmManagerProvider, pumpManagerProvider: pumpManagerProvider, serviceProvider: serviceProvider)
        self.preferredGlucoseUnitViewModel = PreferredGlucoseUnitViewModel(preferredGlucoseUnit: preferredGlucoseUnit)

        super.init(rootView: OnboardingRootView(onboardingViewModel: onboardingViewModel, preferredGlucoseUnitViewModel: preferredGlucoseUnitViewModel, colorPalette: colorPalette))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.onboardingViewModel.completionDelegate = self
    }

    // MARK: - PreferredGlucoseUnitObserver
    func preferredGlucoseUnitDidChange(to preferredGlucoseUnit: HKUnit) {
        preferredGlucoseUnitViewModel.preferredGlucoseUnitDidChange(to: preferredGlucoseUnit)
    }
}

extension OnboardingRootViewController: CompletionDelegate {
    func completionNotifyingDidComplete(_ object: CompletionNotifying) {
        completionDelegate?.completionNotifyingDidComplete(self)
    }
}
