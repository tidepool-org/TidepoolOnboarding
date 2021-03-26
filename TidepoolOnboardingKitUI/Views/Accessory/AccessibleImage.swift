//
//  AccessibleImage.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/22/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct AccessibleImage: View {
    private let name: String
    private let decorative: Bool
    private let width: CGFloat

    @ScaledMetric private var scalingFactor: CGFloat = 1

    init(_ name: String, width: CGFloat = 44) {
        self.name = name
        self.decorative = false
        self.width = width
    }

    init(decorative name: String, width: CGFloat = 44) {
        self.name = name
        self.decorative = true
        self.width = width
    }

    var body: some View {
        Image(frameworkImage: name, decorative: decorative)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width * scalingFactor)
    }
}

struct AccessibleImage_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            Group {
                AccessibleImage("Welcome_1")
                AccessibleImage("Welcome_1", width: 100)
            }
        }
    }
}
