//
//  PresentableImage.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct PresentableImage: View {
    private let name: String
    private let decorative: Bool

    init(_ name: String) {
        self.name = name
        self.decorative = false
    }

    init(decorative name: String) {
        self.name = name
        self.decorative = true
    }

    var body: some View {
        Image(frameworkImage: name, decorative: decorative)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}

struct PresentableImage_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            PresentableImage("Welcome_1")
        }
    }
}
