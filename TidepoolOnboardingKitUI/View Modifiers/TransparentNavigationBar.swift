//
//  TransparentNavigationBar.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

extension View {
    func navigationBarTransparent(_ transparent: Bool) -> some View {
        modifier(TransparentNavigationBar(transparent))
    }
}

// Sets standard appearance of navigation bar to use clear shadow color
// Must be applied to parent view containing NavigationView that desires transparent navigation bar
// Restores previous standard appearance when view disappears
fileprivate struct TransparentNavigationBar: ViewModifier {
    private let transparent: Bool
    private let previousAppearance: UINavigationBarAppearance

    init(_ transparent: Bool) {
        self.transparent = transparent
        self.previousAppearance = UINavigationBar.appearance().standardAppearance
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                if transparent {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.shadowColor = .clear

                    UINavigationBar.appearance().standardAppearance = appearance
                }
            }
            .onDisappear {
                if transparent {
                    UINavigationBar.appearance().standardAppearance = previousAppearance
                }
            }
    }
}
