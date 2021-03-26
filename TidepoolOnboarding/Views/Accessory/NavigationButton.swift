//
//  NavigationButton.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
    @State private var isActive: Bool = false

    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination, isActive: $isActive) {
            ActionButton(title: title, action: { isActive = true })
        }
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        ContentPreview {
            NavigationView {
                ScrollView {
                    NavigationButton(title: "Navigate", destination: Text("Destination"))
                }
                .padding()
                .navigationBarHidden(true)
            }
        }
    }
}
