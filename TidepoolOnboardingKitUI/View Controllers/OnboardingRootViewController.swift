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
    private let displayGlucoseUnitObservable: DisplayGlucoseUnitObservable

    init(cgmManagerProvider: CGMManagerProvider, pumpManagerProvider: PumpManagerProvider, serviceProvider: ServiceProvider, displayGlucoseUnit: HKUnit, colorPalette: LoopUIColorPalette) {
        self.onboardingViewModel = OnboardingViewModel(cgmManagerProvider: cgmManagerProvider, pumpManagerProvider: pumpManagerProvider, serviceProvider: serviceProvider)
        self.displayGlucoseUnitObservable = DisplayGlucoseUnitObservable(displayGlucoseUnit: displayGlucoseUnit)

        super.init(rootView: OnboardingRootView(onboardingViewModel: onboardingViewModel, displayGlucoseUnitObservable: displayGlucoseUnitObservable, colorPalette: colorPalette))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.onboardingViewModel.completionDelegate = self
    }

    // MARK: - DisplayGlucoseUnitObserver
    func displayGlucoseUnitDidChange(to displayGlucoseUnit: HKUnit) {
        displayGlucoseUnitObservable.displayGlucoseUnitDidChange(to: displayGlucoseUnit)
    }
}

extension OnboardingRootViewController: CompletionDelegate {
    func completionNotifyingDidComplete(_ object: CompletionNotifying) {
        completionDelegate?.completionNotifyingDidComplete(self)
    }
}
