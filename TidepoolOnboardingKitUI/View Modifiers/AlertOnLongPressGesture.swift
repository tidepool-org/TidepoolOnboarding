//
//  AlertOnLongPressGesture.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/17/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

extension View {
    func alertOnLongPressGesture(enabled: Bool = true, minimumDuration: Double = 2, title: String, perform action: @escaping () -> Void) -> some View {
        modifier(AlertOnLongPressGesture(enabled: enabled, minimumDuration: minimumDuration, title: title, perform: action))
    }
}

fileprivate struct AlertOnLongPressGesture: ViewModifier {
    @State private var isAlertPresented = false

    private let enabled: Bool
    private let minimumDuration: Double
    private let title: String
    private let action: () -> Void

    init(enabled: Bool, minimumDuration: Double, title: String, perform action: @escaping () -> Void) {
        self.enabled = enabled
        self.minimumDuration = minimumDuration
        self.title = title
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
        Alert(title: Text(title),
              primaryButton: .cancel { isAlertPresented = false },
              secondaryButton: .destructive(Text("Yes"), action: action))
    }
}
