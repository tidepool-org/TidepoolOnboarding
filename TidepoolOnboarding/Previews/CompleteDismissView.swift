//
//  CompleteDismissView.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct CompleteDismissView: View {
    @Environment(\.complete) var complete
    @Environment(\.dismissAction) var dismiss

    var body: some View {
        ScrollView {
            ActionButton(title: "Complete", action: complete)
            ActionButton(title: "Dismiss", action: dismiss)
        }
        .padding()
    }
}

struct CompleteDismissView_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            CompleteDismissView()
        }
    }
}
