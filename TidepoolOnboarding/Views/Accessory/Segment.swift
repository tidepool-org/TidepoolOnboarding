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
    private let content: Content

    init(header: String? = nil, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerView
            content
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private var headerView: some View {
        if let header = header {
            HeaderText(header)
        } else {
            EmptyView()
        }
    }
}
