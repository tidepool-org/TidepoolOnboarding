//
//  TimeInterval.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 1/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Foundation

extension TimeInterval {
    static func days(_ days: Double) -> TimeInterval {
        return TimeInterval(days: days)
    }

    static func days(_ days: Int) -> TimeInterval {
        return TimeInterval(days: days)
    }

    static func hours(_ hours: Double) -> TimeInterval {
        return TimeInterval(hours: hours)
    }

    static func hours(_ hours: Int) -> TimeInterval {
        return TimeInterval(hours: hours)
    }

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

    static func milliseconds(_ milliseconds: Double) -> TimeInterval {
        return TimeInterval(milliseconds: milliseconds)
    }

    static func milliseconds(_ milliseconds: Int) -> TimeInterval {
        return TimeInterval(milliseconds: milliseconds)
    }

    init(days: Double) {
        self.init(hours: days * 24)
    }

    init(days: Int) {
        self.init(hours: days * 24)
    }

    init(hours: Double) {
        self.init(minutes: hours * 60)
    }

    init(hours: Int) {
        self.init(minutes: hours * 60)
    }

    init(minutes: Double) {
        self.init(seconds: minutes * 60)
    }

    init(minutes: Int) {
        self.init(seconds: minutes * 60)
    }

    init(seconds: Double) {
        self.init(seconds)
    }

    init(seconds: Int) {
        self.init(seconds)
    }

    init(milliseconds: Double) {
        self.init(seconds: milliseconds / 1000)
    }

    init(milliseconds: Int) {
        self.init(seconds: Double(milliseconds) / 1000)
    }

    var days: Double {
        return hours / 24
    }

    var hours: Double {
        return minutes / 60
    }

    var minutes: Double {
        return seconds / 60
    }

    var seconds: Double {
        return self
    }

    var milliseconds: Double {
        return seconds * 1000
    }
}
