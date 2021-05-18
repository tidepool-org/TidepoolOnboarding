//
//  Text+AttributedString.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/10/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

extension Text {
    init(_ attributedString: AttributedString) {
        self = attributedString.fragments.reduce(Text("")) { $0 + Text($1) }
    }

    init(_ fragment: AttributedString.Fragment) {
        var text = Text(fragment.string)
        if fragment.attributes?.contains(.bold) == true {
            text = text.bold()
        }
        if fragment.attributes?.contains(.italic) == true {
            text = text.italic()
        }
        self = text
    }
}
