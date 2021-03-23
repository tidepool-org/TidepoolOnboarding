//
//  WarningIcon.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/18/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct WarningIcon: View {
    @ScaledMetric var radius: CGFloat = 20

    var body: some View {
        ZStack {
            Circle()
                .fill()
                .opacity(0.075)
            Circle()
                .stroke(lineWidth: strokeWidth)
                .frame(width: diameter - strokeWidth, height: diameter - strokeWidth)
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: radius * 0.75, height: radius * 0.75)
                .position(x: radius, y: radius * 0.95833) // Difference between vertical center and triangle centroid
        }
        .frame(width: diameter, height: diameter)
    }

    private var diameter: CGFloat { radius * 2 }

    private var strokeWidth: CGFloat { radius / 10 }
}

struct WarningIcon_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            Group {
                WarningIcon()
                WarningIcon(radius: 30)
                    .foregroundColor(.orange)
            }
        }
    }
}
