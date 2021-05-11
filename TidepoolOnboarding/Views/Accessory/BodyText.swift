//
//  BodyText.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BodyText: View {
    private let string: String
    private let isBold: Bool
    private let isItalic: Bool
    private let foregroundColor: Color

    init(_ string: String) {
        self.string = string
        self.isBold = false
        self.isItalic = false
        self.foregroundColor = .accentColor
    }

    var body: some View {
        formattedText
            .accentColor(.secondary)
            .foregroundColor(foregroundColor)
    }

    @ViewBuilder
    var formattedText: some View {
        if isBold && isItalic {
            bodyText.bold().italic()
        } else if isBold {
            bodyText.bold()
        } else if isItalic {
            bodyText.italic()
        } else {
            bodyText
        }
    }

    var bodyText: Text {
        Text(string)
            .font(.body)
    }
}

extension BodyText {
    init(_ other: Self, isBold: Bool? = nil, isItalic: Bool? = nil, foregroundColor: Color? = nil) {
        self.string = other.string
        self.isBold = isBold ?? other.isBold
        self.isItalic = isItalic ?? other.isItalic
        self.foregroundColor = foregroundColor ?? other.foregroundColor
    }

    func bold() -> Self { Self(self, isBold: true) }

    func italic() -> Self { Self(self, isItalic: true) }

    func foregroundColor(_ color: Color) -> Self { Self(self, foregroundColor: color) }
}

struct BodyText_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            BodyText("The quick brown fox jumps over the lazy dog")
        }
    }
}
