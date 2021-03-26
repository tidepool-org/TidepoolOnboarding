//
//  HeaderText.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct HeaderText: View {
    let string: String

    init(_ string: String) {
        self.string = string
    }

    var body: some View {
        Text(string)
            .font(.title2)
            .bold()
            .accessibilityAddTraits(.isHeader)
    }
}

struct HeaderText_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            HeaderText("Extra, Extra, Read All About It!")
        }
    }
}
