//
//  BodyText.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BodyText: View {
    private let attributedString: AttributedString
    private let foregroundColor: Color

    init(_ attributedString: AttributedString) {
        self.attributedString = attributedString
        self.foregroundColor = .black
    }

    init(_ string: String) {
        self.attributedString = AttributedString(string)
        self.foregroundColor = .black
    }

    init(attributed string: String) {
        self.attributedString = AttributedString(attributed: string)
        self.foregroundColor = .black
    }

    var body: some View {
        Text(attributedString)
            .font(.body)
            .accentColor(.secondary)
            .foregroundColor(foregroundColor)
    }
}

extension BodyText {
    init(_ other: Self, isBold: Bool? = nil, isItalic: Bool? = nil, foregroundColor: Color? = nil) {
        var attributedString = other.attributedString
        if isBold == true {
            attributedString = attributedString.bold()
        }
        if isItalic == true {
            attributedString = attributedString.italic()
        }

        self.attributedString = attributedString
        self.foregroundColor = foregroundColor ?? other.foregroundColor
    }

    func bold() -> Self { Self(self, isBold: true) }

    func italic() -> Self { Self(self, isItalic: true) }

    func foregroundColor(_ color: Color?) -> Self { Self(self, foregroundColor: color) }
}

struct BodyText_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            BodyText("The quick brown fox jumps over the lazy dog")
        }
    }
}
