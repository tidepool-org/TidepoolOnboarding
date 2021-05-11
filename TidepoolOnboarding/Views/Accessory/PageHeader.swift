//
//  PageHeader.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct PageHeader: View {
    private let title: String
    private let dividerHidden: Bool

    init(title: String) {
        self.title = title
        self.dividerHidden = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleView
            dividerView
        }
    }

    private var titleView: some View {
        Text(title)
            .font(.largeTitle)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder
    private var dividerView: some View {
        if !dividerHidden {
            Divider()
        } else {
            EmptyView()
        }
    }
}

extension PageHeader {
    init(_ other: Self, dividerHidden: Bool? = nil) {
        self.title = other.title
        self.dividerHidden = dividerHidden ?? other.dividerHidden
    }

    func dividerHidden(_ dividerHidden: Bool) -> Self { Self(self, dividerHidden: dividerHidden) }
}

struct PageHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            PageHeader(title: "Page Header")
        }
    }
}
