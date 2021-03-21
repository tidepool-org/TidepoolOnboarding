//
//  CheckmarkedBodyTextList.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct CheckmarkedBodyTextList: View {
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
                    Checkmark()
                        .foregroundColor(.accentColor)
                        .padding(.trailing, padding)
                    BodyText(strings[index])
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal)
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
            CheckmarkedBodyTextList("Alpha", "Bravo", "Charlie")
        }
    }
}
