//
//  Segment.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/22/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct Segment<Content: View>: View {
    private let header: String?
    private let headerFont: Font
    private let headerSpacing: CGFloat
    private let content: Content

    init(header: String? = nil, @ViewBuilder content: () -> Content) {
        self.header = header
        self.headerFont = .title2
        self.headerSpacing = 20
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: headerSpacing) {
            headerView
            content
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private var headerView: some View {
        if let header = header {
            Text(header)
                .font(headerFont)
                .bold()
                .accessibilityAddTraits(.isHeader)
        } else {
            EmptyView()
        }
    }
}

extension Segment {
    init(_ other: Self, headerFont: Font? = nil, headerSpacing: CGFloat? = nil) {
        self.header = other.header
        self.headerFont = headerFont ?? other.headerFont
        self.headerSpacing = headerSpacing ?? other.headerSpacing
        self.content = other.content
    }

    func headerFont(_ headerFont: Font?) -> Self { Self(self, headerFont: headerFont) }

    func headerSpacing(_ headerSpacing: CGFloat?) -> Self { Self(self, headerSpacing: headerSpacing) }
}
