//
//  OnboardingSectionSheetButton.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/10/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct OnboardingSectionSheetButton<Destination: View, Content: View>: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @EnvironmentObject var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable
    @Environment(\.colorPalette) var colorPalette: LoopUIColorPalette
    @Environment(\.guidanceColors) var guidanceColors: GuidanceColors
    @Environment(\.carbTintColor) var carbTintColor: Color
    @Environment(\.glucoseTintColor) var glucoseTintColor: Color
    @Environment(\.insulinTintColor) var insulinTintColor: Color
    @Environment(\.loopStatusColorPalette) var loopStatusColorPalette: StateColorPalette
    @Environment(\.chartColorPalette) var chartColorPalette: ChartColorPalette
    @Environment(\.appName) var appName: String

    @State private var isActive: Bool = false

    private let section: OnboardingSection
    private let destination: Destination
    private let action: () -> Bool
    private let content: Content

    init(section: OnboardingSection, destination: Destination, action: @escaping () -> Bool = { true }, @ViewBuilder content: () -> Content) {
        self.section = section
        self.destination = destination
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: { isActive = action() }) {
            content
        }
        .sheet(isPresented: $isActive) {
            destination
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
                .environment(\.colorPalette, colorPalette)
                .environment(\.guidanceColors, colorPalette.guidanceColors)
                .environment(\.carbTintColor, colorPalette.carbTintColor)
                .environment(\.glucoseTintColor, colorPalette.glucoseTintColor)
                .environment(\.insulinTintColor, colorPalette.insulinTintColor)
                .environment(\.loopStatusColorPalette, colorPalette.loopStatusColorPalette)
                .environment(\.chartColorPalette, colorPalette.chartColorPalette)
                .environment(\.appName, appName)
                .environment(\.dismiss, {
                    isActive = false
                })
                .environment(\.complete, {
                    // Let sheet dismiss animation finish before completing section (and initiating UI update)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onboardingViewModel.sectionProgression.completeSection(section)
                    }
                    isActive = false
                })
                .onAppear {
                    onboardingViewModel.sectionProgression.startSection(section)
                }
                .presentation(isModal: true)
        }
    }
}

struct OnboardingSectionSheetButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            OnboardingSectionSheetButton(section: .welcome, destination: CompleteDismissView()) {
                Text("Section")
            }
            .buttonStyle(ActionButtonStyle())
            .environmentObject(OnboardingViewModel.preview)
            .environmentObject(DisplayGlucoseUnitObservable.preview)
        }
    }
}
