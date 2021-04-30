//
//  PageHeader.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/15/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct PageHeader: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titleView
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
}

struct PageHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            PageHeader(title: "Page Header")
        }
    }
}
