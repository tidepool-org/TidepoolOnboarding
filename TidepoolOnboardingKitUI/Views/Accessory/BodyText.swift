//
//  BodyText.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BodyText: View {
    let string: String

    init(_ string: String) {
        self.string = string
    }

    var body: some View {
        Text(string)
            .font(.body)
            .accentColor(.secondary)
            .foregroundColor(.accentColor)
    }
}

struct BodyText_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            BodyText("The quick brown fox jumps over the lazy dog")
        }
    }
}
