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
    private let page: Int?
    private let total: Int?

    init(title: String) {
        self.title = title
        self.page = nil
        self.total = nil
    }

    init(title: String, page: Int, of total: Int) {
        self.title = title
        self.page = page
        self.total = total
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleView
            pageView
                .padding(.bottom, 10)
            Divider()
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
    private var pageView: some View {
        if let page = page, let total = total {
            Text(String(format: LocalizedString("%d of %d", comment: "Onboarding page header pager label (1: current page, 2: total pages)"), page, total))
                .font(.subheadline)
                .bold()
                .accentColor(.secondary)
                .foregroundColor(.accentColor)
        } else {
            EmptyView()
        }
    }
}

struct PageHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            PageHeader(title: "Page Header", page: 3, of: 4)
        }
    }
}
