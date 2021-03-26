//
//  LoopIcon.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/22/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct LoopIcon: View {
    @Environment(\.colorPalette) var colorPalette: LoopUIColorPalette

    enum Automation {
        case closed
        case open
    }

    enum Freshness {
        case fresh
        case aging
        case stale
    }

    private let freshness: Freshness
    private let automation: Automation
    private let size: CGFloat

    @ScaledMetric private var scalingFactor: CGFloat = 1

    init(automation: Automation, freshness: Freshness, size: CGFloat = 44) {
        self.automation = automation
        self.freshness = freshness
        self.size = size
    }

    var body: some View {
        LoopShape(automation: automation)
            .stroke(lineWidth: scaledSize * 0.1818)
            .frame(width: scaledSize, height: scaledSize)
            .foregroundColor(foregroundColor)
    }

    private var scaledSize: CGFloat { size * scalingFactor }

    private var foregroundColor: Color {
        switch freshness {
        case .fresh:
            return Color(colorPalette.loopStatusColorPalette.normal)
        case .aging:
            return Color(colorPalette.loopStatusColorPalette.warning)
        case .stale:
            return Color(colorPalette.loopStatusColorPalette.error)
        }
    }

    private struct LoopShape: Shape {
        let automation: Automation

        func path(in rect: CGRect) -> Path {
            return Path(UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY),
                                     radius: min(rect.width / 2, rect.height / 2) * 0.8182,
                                     startAngle: automation == .open ? -CGFloat.pi / 4 : 0,
                                     endAngle: automation == .open ? 5 * CGFloat.pi / 4 : 2 * CGFloat.pi,
                                     clockwise: true).cgPath)
        }
    }
}

struct LoopIcon_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            Group {
                LoopIcon(automation: .closed, freshness: .fresh)
                LoopIcon(automation: .open, freshness: .fresh)
                LoopIcon(automation: .closed, freshness: .aging)
                LoopIcon(automation: .open, freshness: .aging)
                LoopIcon(automation: .closed, freshness: .stale)
                LoopIcon(automation: .open, freshness: .stale)
            }
        }
    }
}
