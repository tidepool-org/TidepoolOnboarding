//
//  Callout.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/17/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct Callout<Content: View>: View {
    private let title: String
    private let warningIconColor: Color
    private let content: Content?

    init(title: String, warningIconColor: Color = .orange, @ViewBuilder content: () -> Content) {
        self.title = title
        self.warningIconColor = warningIconColor
        self.content = content()
    }

    init(title: String, warningIconColor: Color = .orange) where Content == EmptyView {
        self.title = title
        self.warningIconColor = warningIconColor
        self.content = nil
    }

    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    WarningIcon(radius: 20)
                        .foregroundColor(warningIconColor)
                    Text(title)
                        .font(.headline)
                        .bold()
                        .padding(.leading, 5)
                        .layoutPriority(1)
                }
                .fixedSize(horizontal: false, vertical: true)
                if let content = content {
                    Segment {
                        content
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color(.systemFill), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct Callout_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            Callout(title: "Note: Lorem ipsum", warningIconColor: .red) {
                VStack(alignment: .leading, spacing: 20) {
                    BodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    BodyText("Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                    BodyText("Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
                    BodyText("Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                }
            }
        }
    }
}
