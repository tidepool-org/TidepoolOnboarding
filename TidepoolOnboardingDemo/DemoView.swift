//
//  DemoView.swift
//  TidepoolOnboardingDemo
//
//  Created by Darin Krauss on 3/19/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct DemoView: View {
    @EnvironmentObject private var viewModel: DemoViewModel

    @State private var isComplete: Bool = false

    var body: some View {
        if !isComplete {
            DemoOnboardingView()
                .onReceive(viewModel.$isComplete) { isComplete = $0 }
        } else {
            Text("Complete!")
                .font(.largeTitle)
        }
    }
}
