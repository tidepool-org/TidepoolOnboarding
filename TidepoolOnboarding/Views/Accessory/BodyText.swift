//
//  BodyText.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct BodyText: View {
    @Environment(\.font) private var font
    
    private let text: Text
    private let foregroundColor: Color

    init(_ attributedString: AttributedString) {
        self.text = Text(attributedString)
        self.foregroundColor = .primary
    }

    init(_ string: String) {
        self.text = Text(AttributedString(string))
        self.foregroundColor = .primary
    }
    
    init(_ text: Text) {
        self.text = text
        self.foregroundColor = .primary
    }

    init(attributed string: String) {
        self.text = Text(AttributedString(attributed: string))
        self.foregroundColor = .primary
    }

    var body: some View {
        text
            .font(font ?? .body)
            .accentColor(.secondary)
            .foregroundColor(foregroundColor)
    }
}

extension BodyText {
    init(_ other: Self, isBold: Bool? = nil, isItalic: Bool? = nil, foregroundColor: Color? = nil) {
        var text = other.text
        if isBold == true {
            text = text.bold()
        }
        if isItalic == true {
            text = text.italic()
        }

        self.text = text
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
