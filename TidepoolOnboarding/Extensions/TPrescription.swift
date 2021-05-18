//
//  TPrescription.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 4/28/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import HealthKit
import LoopKit
import TidepoolKit

extension TPrescription {
    var therapySettings: LoopKit.TherapySettings? {
        guard let initialSettings = latestRevision?.attributes?.initialSettings,
              let bloodGlucoseUnits = initialSettings.bloodGlucoseUnits?.bloodGlucoseUnits else {
            return nil
        }

        var correctionRangeOverrides: CorrectionRangeOverrides?
        let preMeal = initialSettings.bloodGlucoseTargetPreprandial?.doubleRange
        let workout = initialSettings.bloodGlucoseTargetPhysicalActivity?.doubleRange
        if preMeal != nil || workout != nil {
            correctionRangeOverrides = CorrectionRangeOverrides(preMeal: preMeal, workout: workout, unit: bloodGlucoseUnits)
        }

        var suspendThreshold: GlucoseThreshold?
        if let glucoseSafetyLimit = initialSettings.glucoseSafetyLimit {
            suspendThreshold = GlucoseThreshold(unit: bloodGlucoseUnits, value: glucoseSafetyLimit)
        }

        return LoopKit.TherapySettings(glucoseTargetRangeSchedule: initialSettings.bloodGlucoseTargetSchedule?.glucoseTargetRangeSchedule(in: bloodGlucoseUnits),
                                       correctionRangeOverrides: correctionRangeOverrides,
                                       maximumBasalRatePerHour: initialSettings.basalRateMaximum?.maximumBasalRatePerHour,
                                       maximumBolus: initialSettings.bolusAmountMaximum?.maximumBolus,
                                       suspendThreshold: suspendThreshold,
                                       insulinSensitivitySchedule: initialSettings.insulinSensitivitySchedule?.insulinSensitivitySchedule(in: bloodGlucoseUnits),
                                       carbRatioSchedule: initialSettings.carbohydrateRatioSchedule?.carbRatioSchedule,
                                       basalRateSchedule: initialSettings.basalRateSchedule?.basalRateSchedule,
                                       insulinModelSettings: initialSettings.insulinModel?.insulinModelSettings)
    }
}

extension TPrescription {
    static var mock: TPrescription {
        let initialSettings = TPrescription.InitialSettings(bloodGlucoseUnits: .milligramsPerDeciliter,
                                                            basalRateSchedule: [
                                                                TPrescription.BasalRateStart(start: 0, rate: 1.0),
                                                                TPrescription.BasalRateStart(start: 21600000, rate: 1.5),
                                                                TPrescription.BasalRateStart(start: 64800000, rate: 1.25)
                                                            ],
                                                            bloodGlucoseTargetPhysicalActivity: TPrescription.BloodGlucoseTarget(low: 150, high: 160),
                                                            bloodGlucoseTargetPreprandial: TPrescription.BloodGlucoseTarget(low: 80, high: 90),
                                                            bloodGlucoseTargetSchedule: [
                                                                TPrescription.BloodGlucoseStartTarget(start: 0, low: 105, high: 115),
                                                                TPrescription.BloodGlucoseStartTarget(start: 21600000, low: 100, high: 110),
                                                                TPrescription.BloodGlucoseStartTarget(start: 79200000, low: 105, high: 115),
                                                            ],
                                                            carbohydrateRatioSchedule: [
                                                                TPrescription.CarbohydrateRatioStart(start: 0, amount: 15),
                                                                TPrescription.CarbohydrateRatioStart(start: 21600000, amount: 12),
                                                                TPrescription.CarbohydrateRatioStart(start: 43200000, amount: 15)
                                                            ],
                                                            glucoseSafetyLimit: 80,
                                                            insulinModel: .rapidChild,
                                                            insulinSensitivitySchedule: [
                                                                TPrescription.InsulinSensitivityStart(start: 0, amount: 55.0),
                                                                TPrescription.InsulinSensitivityStart(start: 21600000, amount: 45.0),
                                                                TPrescription.InsulinSensitivityStart(start: 79200000, amount: 55.0),
                                                            ],
                                                            basalRateMaximum: TPrescription.BasalRateMaximum(4.5, .unitsPerHour),
                                                            bolusAmountMaximum: TPrescription.BolusAmountMaximum(10, .units),
                                                            pumpId: "6678c377-928c-49b3-84c1-19e2dafaff8d",
                                                            cgmId: "d25c3f1b-a2e8-44e2-b3a3-fd07806fc245")
        let attributes = TPrescription.Attributes(accountType: .caregiver,
                                                  caregiverFirstName: "Parent",
                                                  caregiverLastName: "Doe",
                                                  firstName: "Child",
                                                  lastName: "Doe",
                                                  birthday: "2004-01-04",
                                                  mrn: "1234567890",
                                                  email: "parent.doe@email.com",
                                                  sex: .undisclosed,
                                                  weight: TPrescription.Weight(value: 65, units: .kg),
                                                  yearOfDiagnosis: 2010,
                                                  phoneNumber: TPrescription.PhoneNumber(countryCode: 1, number: "555-1212"),
                                                  initialSettings: initialSettings,
                                                  training: .inModule,
                                                  therapySettings: .initial,
                                                  prescriberTermsAccepted: true,
                                                  state: .submitted,
                                                  createdTime: dateFormatter.date(from: "2021-04-28T20:19:30.841Z"),
                                                  createdUserId: "42cb2e2f-b0e7-4168-a30f-a2738777027a")
        return TPrescription(id: "6089c35220398b38a71f2103",
                             patientUserId: "dd8373e3-992e-4801-a17e-08b49b4f3ade",
                             state: .claimed,
                             latestRevision: TPrescription.Revision(revisionId: 0, attributes: attributes),
                             prescriberUserId: "42cb2e2f-b0e7-4168-a30f-a2738777027a",
                             createdTime: dateFormatter.date(from: "2021-04-28T20:19:30.841Z"),
                             createdUserId: "42cb2e2f-b0e7-4168-a30f-a2738777027a",
                             modifiedTime: dateFormatter.date(from: "2021-04-28T20:19:30.841Z"),
                             modifiedUserId: "42cb2e2f-b0e7-4168-a30f-a2738777027a")
    }

    fileprivate static var dateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter
    }()
}

fileprivate extension TBloodGlucose.Units {
    var bloodGlucoseUnits: HKUnit {
        switch self {
        case .milligramsPerDeciliter:
            return .milligramsPerDeciliter
        case .millimolesPerLiter:
            return .millimolesPerLiter
        }
    }
}

fileprivate extension Array where Element == TPrescription.BasalRateStart {
    var basalRateSchedule: BasalRateSchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return BasalRateSchedule(dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.BasalRateStart {
    var repeatingScheduleValue: RepeatingScheduleValue<Double>? {
        guard let start = start, let rate = rate else {
            return nil
        }

        return RepeatingScheduleValue(startTime: .milliseconds(start), value: rate)
    }
}

fileprivate extension TPrescription.BloodGlucoseTarget {
    var doubleRange: DoubleRange? {
        guard let low = low, let high = high, target == nil, range == nil else {
            return nil
        }

        return DoubleRange(minValue: low, maxValue: high)
    }
}

fileprivate extension Array where Element == TPrescription.BloodGlucoseStartTarget {
    func glucoseTargetRangeSchedule(in unit: HKUnit) -> GlucoseRangeSchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return GlucoseRangeSchedule(unit: unit, dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.BloodGlucoseStartTarget {
    var repeatingScheduleValue: RepeatingScheduleValue<DoubleRange>? {
        guard let start = start, let low = low, let high = high, target == nil, range == nil else {
            return nil
        }

        return RepeatingScheduleValue(startTime: .milliseconds(start), value: DoubleRange(minValue: low, maxValue: high))
    }
}

fileprivate extension Array where Element == TPrescription.CarbohydrateRatioStart {
    var carbRatioSchedule: CarbRatioSchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return CarbRatioSchedule(unit: .gram(), dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.CarbohydrateRatioStart {
    var repeatingScheduleValue: RepeatingScheduleValue<Double>? {
        guard let start = start, let amount = amount else {
            return nil
        }

        return RepeatingScheduleValue(startTime: .milliseconds(start), value: amount)
    }
}

fileprivate extension TPrescription.InsulinModelType {
    var insulinModelSettings: InsulinModelSettings? {
        switch self {
        case .fiasp:
            return InsulinModelSettings(model: ExponentialInsulinModelPreset.fiasp)
        case .other:
            return nil
        case .rapidAdult:
            return InsulinModelSettings(model: ExponentialInsulinModelPreset.humalogNovologAdult)
        case .rapidChild:
            return InsulinModelSettings(model: ExponentialInsulinModelPreset.humalogNovologChild)
        case .walsh:
            return nil
        }
    }
}

fileprivate extension Array where Element == TPrescription.InsulinSensitivityStart {
    func insulinSensitivitySchedule(in unit: HKUnit) -> InsulinSensitivitySchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return InsulinSensitivitySchedule(unit: unit, dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.InsulinSensitivityStart {
    var repeatingScheduleValue: RepeatingScheduleValue<Double>? {
        guard let start = start, let amount = amount else {
            return nil
        }

        return RepeatingScheduleValue(startTime: .milliseconds(start), value: amount)
    }
}

fileprivate extension TPrescription.BasalRateMaximum {
    var maximumBasalRatePerHour: Double? { value }
}

fileprivate extension TPrescription.BolusAmountMaximum {
    var maximumBolus: Double? { value }
}
