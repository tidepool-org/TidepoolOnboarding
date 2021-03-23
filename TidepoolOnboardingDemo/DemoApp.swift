//
//  DemoApp.swift
//  TidepoolOnboardingDemo
//
//  Created by Darin Krauss on 3/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

@main
struct DemoApp: App {
    private let viewModel = DemoViewModel()

    var body: some Scene {
        WindowGroup {
            DemoView()
                .environmentObject(viewModel)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
