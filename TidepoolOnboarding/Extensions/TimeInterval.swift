//
//  TimeInterval.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation

extension TimeInterval {
    static func minutes(_ minutes: Double) -> TimeInterval {
        return TimeInterval(minutes: minutes)
    }

    static func minutes(_ minutes: Int) -> TimeInterval {
        return TimeInterval(minutes: minutes)
    }

    static func seconds(_ seconds: Double) -> TimeInterval {
        return TimeInterval(seconds: seconds)
    }

    static func seconds(_ seconds: Int) -> TimeInterval {
        return TimeInterval(seconds: seconds)
    }

    init(minutes: Double) {
        self.init(minutes * 60)
    }

    init(minutes: Int) {
        self.init(minutes * 60)
    }

    init(seconds: Double) {
        self.init(seconds)
    }

    init(seconds: Int) {
        self.init(seconds)
    }

    var minutes: Double {
        return self / 60.0
    }

    var seconds: Double {
        return self
    }
}
