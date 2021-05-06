//
//  NumberedBodyTextList.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 4/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct NumberedBodyTextList: View {
    private let strings: [String]

    init(_ strings: [String]) {
        self.strings = strings
    }

    init(_ strings: String...) {
        self.strings = strings
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(strings.indices) { index in
                HStack(spacing: 10) {
                    Number(index + 1)
                        .foregroundColor(.accentColor)
                    BodyText(strings[index])
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityValue(accessibilityValue(for: index))
            }
        }
    }

    private func accessibilityValue(for index: Int) -> String {
        String(format: LocalizedString("%d, %2$@", comment: "Accessibility value for numbered list item (1: item number)(2: item text)"), index + 1, strings[index])
    }

    private struct Number: View {
        private let number: Int

        @ScaledMetric var size: CGFloat = 21

        init(_ number: Int) {
            self.number = number
        }

        var body: some View {
            ZStack {
                Circle()
                    .frame(width: size, height: size)
                Text("\(number)")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }
    }
}

struct NumberedBodyTextList_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            NumberedBodyTextList("Uno", "Dos", "Tres Amigos")
        }
    }
}
