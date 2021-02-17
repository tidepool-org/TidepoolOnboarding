//
//  OnboardingRootView.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI

struct OnboardingRootView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @ObservedObject private var preferredGlucoseUnitViewModel: PreferredGlucoseUnitViewModel
    private let colorPalette: LoopUIColorPalette

    init(onboardingViewModel: OnboardingViewModel, preferredGlucoseUnitViewModel: PreferredGlucoseUnitViewModel, colorPalette: LoopUIColorPalette) {
        self.onboardingViewModel = onboardingViewModel
        self.preferredGlucoseUnitViewModel = preferredGlucoseUnitViewModel
        self.colorPalette = colorPalette
    }

    var body: some View {
        rootView
            .environmentObject(preferredGlucoseUnitViewModel)
            .environment(\.colorPalette, colorPalette)
    }

    @ViewBuilder
    private var rootView: some View {
        if !onboardingViewModel.isWelcomeComplete {
            welcomeView
        } else {
            prescriptionReviewView
        }
    }

    private var welcomeView: some View {
        OnboardingWelcomeTabView()
            .environment(\.complete, { onboardingViewModel.isWelcomeComplete = true })
    }

    private var prescriptionReviewView: some View {
        PrescriptionReviewViewController(onboardingDelegate: onboardingViewModel, completionDelegate: onboardingViewModel)
    }
}

struct OnboardingRootView_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreview {
            OnboardingRootView(onboardingViewModel: OnboardingViewModel.preview,
                               preferredGlucoseUnitViewModel: PreferredGlucoseUnitViewModel.preview,
                               colorPalette: LoopUIColorPalette.preview)
        }
    }
}

extension OnboardingViewModel {
    static var preview: OnboardingViewModel {
        return OnboardingViewModel(cgmManagerProvider: PreviewCGMManagerProvider(), pumpManagerProvider: PreviewPumpManagerProvider(), serviceProvider: PreviewServiceProvider())
    }
}

extension PreferredGlucoseUnitViewModel {
    static var preview: PreferredGlucoseUnitViewModel {
        return PreferredGlucoseUnitViewModel(preferredGlucoseUnit: .milligramsPerDeciliter)
    }
}

extension LoopUIColorPalette {
    static var preview: LoopUIColorPalette {
        return LoopUIColorPalette(guidanceColors: GuidanceColors(),
                                  carbTintColor: .green,
                                  glucoseTintColor: Color(.systemTeal),
                                  insulinTintColor: .orange,
                                  chartColorPalette: ChartColorPalette(axisLine: .clear,
                                                                       axisLabel: .secondaryLabel,
                                                                       grid: .systemGray3,
                                                                       glucoseTint: .systemTeal,
                                                                       insulinTint: .orange))
    }
}

class PreviewCGMManagerProvider: CGMManagerProvider {
    var activeCGMManager: CGMManager? = nil
    var availableCGMManagers: [CGMManagerDescriptor] = []
    func setupCGMManager(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CGMManagerCreateNotifying & CGMManagerOnboardNotifying & CompletionNotifying, CGMManager>, Error> {
        .failure(PreviewError())
    }
}

class PreviewPumpManagerProvider: PumpManagerProvider {
    var activePumpManager: PumpManager? = nil
    var availablePumpManagers: [PumpManagerDescriptor] = []
    func setupPumpManager(withIdentifier identifier: String, initialSettings settings: PumpManagerSetupSettings) -> Result<SetupUIResult<UIViewController & CompletionNotifying & PumpManagerCreateNotifying & PumpManagerOnboardNotifying, PumpManager>, Error> {
        .failure(PreviewError())
    }
}

class PreviewServiceProvider: ServiceProvider {
    var activeServices: [Service] = []
    var availableServices: [ServiceDescriptor] = []
    func setupService(withIdentifier identifier: String) -> Result<SetupUIResult<UIViewController & CompletionNotifying & ServiceCreateNotifying & ServiceOnboardNotifying, Service>, Error> {
        .failure(PreviewError())
    }
}

struct PreviewError: Error {}
