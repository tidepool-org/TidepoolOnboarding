//
//  OnboardingTabView.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct OnboardingTabView: View {
    @Environment(\.complete) var complete

    @State private var selectedTabIndex = 0

    var tabs: [AnyView]

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                TabView(selection: $selectedTabIndex) {
                    ForEach(tabs.indices) { tabIndex in
                        ScrollView {
                            VStack {
                                tabs[tabIndex]
                                Spacer()
                                pager(for: tabIndex)
                                    .padding(.vertical)
                                button(for: tabIndex)
                            }
                            .padding()
                            .frame(minHeight: geometry.size.height)
                        }
                        .tag(tabIndex)
                        .navigationBarHidden(true)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }

    private func pager(for index: Int) -> some View {
        HStack() {
            ForEach(tabs.indices) { tabIndex in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(tabIndex == index ? .accentColor : .gray)
            }
        }
    }

    @ViewBuilder
    private func button(for index: Int) -> some View {
        if index < tabs.count - 1 {
            ActionButton(title: "Continue", action: { selectedTabIndex += 1 })
        } else {
            ActionButton(title: "Finish", action: complete)
        }
    }
}

struct OnboardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentPreview {
            OnboardingTabView(tabs: [AnyView(Text("One")), AnyView(Text("Two")), AnyView(Text("Three"))])
        }
    }
}
