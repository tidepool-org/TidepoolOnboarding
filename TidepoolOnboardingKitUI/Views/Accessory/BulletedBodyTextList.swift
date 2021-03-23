//
//  BulletedBodyTextList.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BulletedBodyTextList: View {
    private let strings: [String]
    
    @ScaledMetric var padding: CGFloat = 5
    
    init(_ strings: [String]) {
        self.strings = strings
    }
    
    init(_ strings: String...) {
        self.strings = strings
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(strings.indices) { index in
                HStack {
                    Bullet()
                        .foregroundColor(.accentColor)
                        .padding(.trailing, padding)
                    BodyText(strings[index])
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private struct Bullet: View {
        @ScaledMetric var size: CGFloat = 8
        
        var body: some View {
            Circle()
                .frame(width: size, height: size)
                .opacity(0.5)
        }
    }
}

struct BulletedBodyTextList_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            BulletedBodyTextList("First", "Second", "Third")
        }
    }
}
