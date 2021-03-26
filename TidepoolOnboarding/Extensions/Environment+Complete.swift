//
//  Environment+Complete.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

private struct CompletionKey: EnvironmentKey {
    static let defaultValue = {}
}

extension EnvironmentValues {
    public var complete: () -> Void {
        get { self[CompletionKey.self] }
        set { self[CompletionKey.self] = newValue }
    }
}
