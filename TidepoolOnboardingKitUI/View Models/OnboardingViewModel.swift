//
//  OnboardingViewModel.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation
import LoopKit
import LoopKitUI

class OnboardingViewModel: ObservableObject, OnboardingNotifying, CGMManagerCreateNotifying, CGMManagerOnboardNotifying, PumpManagerCreateNotifying, PumpManagerOnboardNotifying, ServiceCreateNotifying, ServiceOnboardNotifying, CompletionNotifying {
    weak var onboardingDelegate: OnboardingDelegate?
    weak var cgmManagerCreateDelegate: CGMManagerCreateDelegate?
    weak var cgmManagerOnboardDelegate: CGMManagerOnboardDelegate?
    weak var pumpManagerCreateDelegate: PumpManagerCreateDelegate?
    weak var pumpManagerOnboardDelegate: PumpManagerOnboardDelegate?
    weak var serviceCreateDelegate: ServiceCreateDelegate?
    weak var serviceOnboardDelegate: ServiceOnboardDelegate?
    weak var completionDelegate: CompletionDelegate?

    private let cgmManagerProvider: CGMManagerProvider
    private let pumpManagerProvider: PumpManagerProvider
    private let serviceProvider: ServiceProvider

    @Published var isWelcomeComplete: Bool = false

    init(cgmManagerProvider: CGMManagerProvider, pumpManagerProvider: PumpManagerProvider, serviceProvider: ServiceProvider) {
        self.cgmManagerProvider = cgmManagerProvider
        self.pumpManagerProvider = pumpManagerProvider
        self.serviceProvider = serviceProvider
    }

    private func notifyComplete() {
        self.completionDelegate?.completionNotifyingDidComplete(self)
    }
}

extension OnboardingViewModel: OnboardingDelegate {
    func onboardingNotifying(hasNewTherapySettings therapySettings: TherapySettings) {
        onboardingDelegate?.onboardingNotifying(hasNewTherapySettings: therapySettings)
    }
}

extension OnboardingViewModel: CompletionDelegate {
    func completionNotifyingDidComplete(_ object: CompletionNotifying) {
        if let prescriptionReviewUICoordinator = object as? PrescriptionReviewUICoordinator {
            prescriptionReviewUICoordinator.dismiss(animated: true)
            notifyComplete()
        }
    }
}
