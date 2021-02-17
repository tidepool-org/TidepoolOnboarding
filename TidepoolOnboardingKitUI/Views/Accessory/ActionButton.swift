//
//  ActionButton.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct ActionButton: View {
    private let title: String
    private let action: () -> Void

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
        }.buttonStyle(ActionButtonStyle())
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreview {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    ActionButton(title: "Continue", action: {})
                }
                .padding()
            }
        }
    }
}
