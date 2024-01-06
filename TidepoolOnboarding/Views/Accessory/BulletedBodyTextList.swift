//
//  BulletedBodyTextList.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BulletedBodyTextList: View {
    enum BulletType {
        case filledCircle
        case noBullet
    }
    
    @Environment(\.font) private var font
    
    private let bullets: [(BulletType, AttributedString)]

    init(_ attributedStrings: AttributedString...) {
        self.init(attributedStrings.map { (.filledCircle, $0) })
    }
    
    init(_ strings: String...) {
        self.init(strings.map { (.filledCircle, AttributedString($0)) })
    }
    
    init(attributed strings: String...) {
        self.init(strings.map { (.filledCircle, AttributedString(attributed: $0)) })
    }
    
    init(_ bullets: [(BulletType, AttributedString)]) {
        self.bullets = bullets
    }

    init(attributed bullets: (BulletType, String)...) {
        self.bullets = bullets.map { ($0.0, AttributedString(attributed: $0.1)) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(bullets.indices) { index in
                HStack(spacing: 10) {
                    bullet(bullets[index].0)
                    BodyText(bullets[index].1)
                        .font(font)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func bullet(_ type: BulletType) -> some View {
        Group {
            switch type {
            case .filledCircle: FilledCircle()
            case .noBullet: NoBullet()
            }
        }
    }
}
    
struct FilledCircle: View {
    @ScaledMetric var size: CGFloat = 8

    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .opacity(0.5)
            .foregroundColor(.accentColor)
    }
}

struct NoBullet: View {
    @ScaledMetric var size: CGFloat = 8

    var body: some View {
        Spacer()
            .frame(width: size, height: size)
    }
}

struct BulletedBodyTextList_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            BulletedBodyTextList("First", "Second", "Close Encounters of the Third Kind")
        }
    }
}
