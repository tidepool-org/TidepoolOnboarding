//
//  TidepoolOnboardingPlugin.swift
//  TidepoolOnboardingPlugin
//
//  Created by Darin Krauss on 12/10/20.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import os.log
import LoopKitUI
import TidepoolOnboardingKit
import TidepoolOnboardingKitUI

class TidepoolOnboardingPlugin: NSObject, OnboardingUIPlugin {
    private let log = OSLog(category: "TidepoolOnboardingPlugin")

    public var onboardingType: OnboardingUI.Type? {
        return TidepoolOnboarding.self
    }

    override init() {
        super.init()
        log.default("Instantiated")
    }
}
