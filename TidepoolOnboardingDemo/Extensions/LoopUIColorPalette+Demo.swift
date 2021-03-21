//
//  LoopUIColorPalette+Demo.swift
//  TidepoolOnboardingDemo
//
//  Created by Darin Krauss on 3/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import LoopKitUI

extension LoopUIColorPalette {
    static var demo: LoopUIColorPalette {
        LoopUIColorPalette(guidanceColors: GuidanceColors(acceptable: .green,
                                                          warning: .yellow,
                                                          critical: .red),
                           carbTintColor: .green,
                           glucoseTintColor: .blue,
                           insulinTintColor: .orange,
                           chartColorPalette: ChartColorPalette(axisLine: .label,
                                                                axisLabel: .label,
                                                                grid: .secondaryLabel,
                                                                glucoseTint: .blue,
                                                                insulinTint: .orange))
    }
}
