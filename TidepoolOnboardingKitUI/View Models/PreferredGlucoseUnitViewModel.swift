//
//  PreferredGlucoseUnitViewModel.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 1/29/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation
import HealthKit
import LoopKitUI

class PreferredGlucoseUnitViewModel: ObservableObject {
    @Published var preferredGlucoseUnit: HKUnit

    init(preferredGlucoseUnit: HKUnit) {
        self.preferredGlucoseUnit = preferredGlucoseUnit
    }
}

extension PreferredGlucoseUnitViewModel: PreferredGlucoseUnitObserver {
    func preferredGlucoseUnitDidChange(to preferredGlucoseUnit: HKUnit) {
        self.preferredGlucoseUnit = preferredGlucoseUnit
    }
}
