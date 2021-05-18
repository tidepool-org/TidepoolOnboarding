//
//  BulletedBodyTextList.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BulletedBodyTextList: View {
    private let attributedStrings: [AttributedString]

    init(_ attributedStrings: AttributedString...) {
        self.attributedStrings = attributedStrings
    }
    
    init(_ strings: String...) {
        self.attributedStrings = strings.map { AttributedString($0) }
    }
    
    init(attributed strings: String...) {
        self.attributedStrings = strings.map { AttributedString(attributed: $0) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(attributedStrings.indices) { index in
                HStack(spacing: 10) {
                    Bullet()
                    BodyText(attributedStrings[index])
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal)
    }
}
    
struct Bullet: View {
    @ScaledMetric var size: CGFloat = 8

    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .opacity(0.5)
            .foregroundColor(.accentColor)
    }
}

struct BulletedBodyTextList_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            BulletedBodyTextList("First", "Second", "Close Encounters of the Third Kind")
        }
    }
}
