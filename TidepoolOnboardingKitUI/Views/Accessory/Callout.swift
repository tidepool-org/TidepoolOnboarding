//
//  Callout.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/17/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct Callout: View {
    let title: String
    let description: String

    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    WarningIcon(radius: 20)
                        .foregroundColor(.orange)
                    Text(title)
                        .font(.headline)
                        .bold()
                        .padding(.leading, 5)
                        .layoutPriority(1)
                }
                .padding(.bottom)
                BodyText(description)
            }
            .padding()
        }
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color(.systemFill), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var warning: some View {
        ZStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .frame(width: 15, height: 15)
                .padding(.leading, 1)
                .padding(.bottom, 2)
            Circle()
                .stroke(lineWidth: 2)
            Circle()
                .fill(Color.orange.opacity(0.05))
        }
        .foregroundColor(.orange)
        .frame(width: 40, height: 40)
    }
}

struct Callout_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            Callout(title: "Note: Lorem ipsum",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        }
    }
}
