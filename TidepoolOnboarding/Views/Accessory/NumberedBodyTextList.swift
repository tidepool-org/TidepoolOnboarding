//
//  NumberedBodyTextList.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 4/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct NumberedBodyTextList: View {
    private let attributedStrings: [AttributedString]
    private let startingAt: Int

    init(_ attributedStrings: AttributedString...) {
        self.attributedStrings = attributedStrings
        self.startingAt = 1
    }

    init(_ strings: String...) {
        self.attributedStrings = strings.map { AttributedString($0) }
        self.startingAt = 1
    }

    init(attributed strings: String...) {
        self.attributedStrings = strings.map { AttributedString(attributed: $0) }
        self.startingAt = 1
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(attributedStrings.indices) { index in
                HStack(spacing: 10) {
                    NumberCircle(startingAt + index)
                    BodyText(attributedStrings[index])
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityValue(accessibilityValue(for: index))
            }
        }
    }

    private func accessibilityValue(for index: Int) -> String {
        String(format: LocalizedString("%d, %2$@", comment: "Accessibility value for numbered list item (1: item number)(2: item text)"), startingAt + index, attributedStrings[index].string)
    }
}

struct NumberCircle: View {
    private let number: Int

    @ScaledMetric var size: CGFloat = 21

    init(_ number: Int) {
        self.number = number
    }

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.accentColor)
                .frame(width: size, height: size)
            Text("\(number)")
                .font(.footnote)
                .foregroundColor(.white)
        }
    }
}

extension NumberedBodyTextList {
    init(_ other: Self, startingAt: Int? = nil) {
        self.attributedStrings = other.attributedStrings
        self.startingAt = startingAt ?? other.startingAt
    }

    func startingAt(_ startingAt: Int?) -> Self { Self(self, startingAt: startingAt) }
}

struct NumberedBodyTextList_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            NumberedBodyTextList("Uno", "Dos", "Tres Amigos")
        }
    }
}
