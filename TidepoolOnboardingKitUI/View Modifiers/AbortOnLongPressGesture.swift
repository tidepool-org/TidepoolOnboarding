//
//  AbortOnLongPressGesture.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/17/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

extension View {
    func abortOnLongPressGesture(enabled: Bool = true, minimumDuration: Double = 2, perform action: @escaping () -> Void) -> some View {
        modifier(AbortOnLongPressGesture(enabled: enabled, minimumDuration: minimumDuration, perform: action))
    }
}

fileprivate struct AbortOnLongPressGesture: ViewModifier {
    @State private var isAlertPresented = false

    private let enabled: Bool
    private let minimumDuration: Double
    private let action: () -> Void

    init(enabled: Bool, minimumDuration: Double, perform action: @escaping () -> Void) {
        self.enabled = enabled
        self.minimumDuration = minimumDuration
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onLongPressGesture(minimumDuration: minimumDuration) {
                if enabled {
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    isAlertPresented = true
                }
            }
            .alert(isPresented: $isAlertPresented) { alert }
    }

    private var alert: Alert {
        Alert(title: Text("Are you sure you want to abort?"),
              primaryButton: .cancel { isAlertPresented = false },
              secondaryButton: .destructive(Text("Abort"), action: action))
    }
}
