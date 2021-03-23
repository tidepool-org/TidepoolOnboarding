//
//  CheckpointCheckmark.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/21/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct CheckpointCheckmark: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 113, height: 113)
                .foregroundColor(.accentColor)
            Spacer()
        }
    }
}

struct CheckpointCheckmark_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreviewWithBackground {
            CheckpointCheckmark()
        }
    }
}
