//
//  CheckmarkedBodyTextList.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct CheckmarkedBodyTextList: View {
    private let strings: [String]

    init(_ strings: [String]) {
        self.strings = strings
    }
    
    init(_ strings: String...) {
        self.strings = strings
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(strings.indices) { index in
                HStack(spacing: 10) {
                    Checkmark()
                        .foregroundColor(.accentColor)
                    BodyText(strings[index])
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    private struct Checkmark: View {
        @ScaledMetric var size: CGFloat = 22
        
        var body: some View {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: size, height: size)
        }
    }
}

struct CheckmarkedBodyTextList_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            CheckmarkedBodyTextList("Alpha", "Bravo", "Charlie Brown and his dog Snoopy")
        }
    }
}
