//
//  PreferredGlucoseUnit.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation
import HealthKit
import LoopKitUI

public class PreferredGlucoseUnit: ObservableObject {
    @Published public var unit: HKUnit

    public init(_ unit: HKUnit) {
        self.unit = unit
    }
}

extension PreferredGlucoseUnit: PreferredGlucoseUnitObserver {
    public func preferredGlucoseUnitDidChange(to preferredGlucoseUnit: HKUnit) {
        self.unit = preferredGlucoseUnit
    }
}
