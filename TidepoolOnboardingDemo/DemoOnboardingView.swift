//
//  DemoOnboardingView.swift
//  TidepoolOnboardingDemo
//
//  Created by Darin Krauss on 3/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct DemoOnboardingView: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: DemoViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        OrientationLock.deviceOrientationController = viewModel
        
        var onboardingViewController = viewModel.onboarding.onboardingViewController(onboardingProvider: viewModel,
                                                                                     displayGlucoseUnitObservable: DisplayGlucoseUnitObservable.demo,
                                                                                     colorPalette: LoopUIColorPalette.demo)
        onboardingViewController.cgmManagerOnboardingDelegate = viewModel
        onboardingViewController.pumpManagerOnboardingDelegate = viewModel
        onboardingViewController.serviceOnboardingDelegate = viewModel
        onboardingViewController.completionDelegate = viewModel
        
        return onboardingViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
