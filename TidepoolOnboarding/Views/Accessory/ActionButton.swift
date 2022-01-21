//
//  ActionButton.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct ActionButton: View {
    typealias Style = ActionButtonStyle.ButtonType

    let title: String
    let style: Style
    let action: () -> Void

    init(title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .multilineTextAlignment(.center)
        }
        .buttonStyle(ActionButtonStyle(style))
        .accessibilityElement()
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(title)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            ActionButton(title: "Action", action: {})
        }
    }
}
