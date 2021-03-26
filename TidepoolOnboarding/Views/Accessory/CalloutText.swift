//
//  CalloutText.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/16/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct CalloutText: View {
    let string: String

    init(_ string: String) {
        self.string = string
    }

    var body: some View {
        Text(string)
            .font(.callout)
            .accentColor(.secondary)
            .foregroundColor(.accentColor)
    }
}

struct CalloutText_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            CalloutText("Calling All Cars!")
        }
    }
}
