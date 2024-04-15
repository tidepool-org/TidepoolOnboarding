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
import TidepoolSupport
import LoopAlgorithm

struct TDevices {
    enum Pump: Identifiable {
        case palmtree
        case palmtreeDemo
        case simulator
        
        var id: String {
            switch self {
            case .palmtree:
                return "0db8cd70-d5c8-4e3d-9ac6-6eb27fd0f36d"
            case .palmtreeDemo:
                return "7b835f64-0cc7-4eb8-b140-5eb5843131c0"
            case .simulator:
                return "14c97adb-5b1e-48ea-ac79-f684412058b7"
            }
        }
    }
    
    enum CGM: Identifiable {
        case dexcomG6
        case dexcomG6Demo
        case simulator
        
        var id: String {
            switch self {
            case .dexcomG6:
                return "d25c3f1b-a2e8-44e2-b3a3-fd07806fc245"
            case .dexcomG6Demo:
                return "15137627-e9ba-4bab-a36d-7c2f0a5ef368"
            case .simulator:
                return "c97bd194-5e5e-44c1-9629-4cb87be1a4c9"
            }
        }
    }
    
    let pump: Pump
    let cgm: CGM
    
    init(
        pump: Pump,
        cgm: CGM
    ) {
        self.pump = pump
        self.cgm = cgm
    }
    
    static var simulatorSpecific: TDevices {
        #if targetEnvironment(simulator)
        TDevices(pump: .palmtreeDemo, cgm: .dexcomG6Demo)
        #else
        TDevices(pump: .palmtree, cgm: .dexcomG6)
        #endif
    }
    
    static func `for`(_ product: TidepoolSupport.Product) -> Self? {
        switch product {
        case .none: return nil
        case .palmtree1: return TDevices(pump: .palmtree, cgm: .dexcomG6Demo)
        case .palmtree2: return TDevices(pump: .palmtreeDemo, cgm: .dexcomG6Demo)
        case .marketingDemo: return TDevices(pump: .simulator, cgm: .simulator)
        }
    }
}

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
                                       defaultRapidActingModel: initialSettings.insulinModel?.defaultRapidActingModel)
    }
}

extension TPrescription {
    static func mock(_ devices: TDevices = .simulatorSpecific) -> TPrescription {
        let initialSettings = TPrescription.Attributes.InitialSettings(bloodGlucoseUnits: .milligramsPerDeciliter,
                                                                       basalRateSchedule: [
                                                                        TPrescription.Attributes.InitialSettings.BasalRateStart(start: .hours(0), rate: 1.0),
                                                                        TPrescription.Attributes.InitialSettings.BasalRateStart(start: .hours(15), rate: 0.85),
                                                                       ],
                                                                       bloodGlucoseTargetPhysicalActivity: TPrescription.Attributes.InitialSettings.BloodGlucoseTarget(low: 140, high: 160),
                                                                       bloodGlucoseTargetPreprandial: TPrescription.Attributes.InitialSettings.BloodGlucoseTarget(low: 80, high: 90),
                                                                       bloodGlucoseTargetSchedule: [
                                                                        TPrescription.Attributes.InitialSettings.BloodGlucoseStartTarget(start: .hours(0), low: 100, high: 110),
                                                                        TPrescription.Attributes.InitialSettings.BloodGlucoseStartTarget(start: .hours(8), low: 105, high: 115),
                                                                        TPrescription.Attributes.InitialSettings.BloodGlucoseStartTarget(start: .hours(21), low: 100, high: 110),
                                                                       ],
                                                                       carbohydrateRatioSchedule: [
                                                                        TPrescription.Attributes.InitialSettings.CarbohydrateRatioStart(start: .hours(0), amount: 10)
                                                                       ],
                                                                       glucoseSafetyLimit: 75,
                                                                       insulinModel: .rapidAdult,
                                                                       insulinSensitivitySchedule: [
                                                                        TPrescription.Attributes.InitialSettings.InsulinSensitivityStart(start: .hours(0), amount: 45.0),
                                                                        TPrescription.Attributes.InitialSettings.InsulinSensitivityStart(start: .hours(9), amount: 55.0),
                                                                       ],
                                                                       basalRateMaximum: TPrescription.Attributes.InitialSettings.BasalRateMaximum(5, .unitsPerHour),
                                                                       bolusAmountMaximum: TPrescription.Attributes.InitialSettings.BolusAmountMaximum(10, .units),
                                                                       pumpId: devices.pump.id,
                                                                       cgmId: devices.cgm.id)
        let attributes = TPrescription.Attributes(accountType: .caregiver,
                                                  caregiverFirstName: "Parent",
                                                  caregiverLastName: "Doe",
                                                  firstName: "Child",
                                                  lastName: "Doe",
                                                  birthday: "2004-01-04",
                                                  mrn: "1234567890",
                                                  email: "parent.doe@email.com",
                                                  sex: .undisclosed,
                                                  weight: TPrescription.Attributes.Weight(value: 65, units: .kg),
                                                  yearOfDiagnosis: 2010,
                                                  phoneNumber: TPrescription.Attributes.PhoneNumber(countryCode: 1, number: "555-1212"),
                                                  initialSettings: initialSettings,
                                                  training: .inModule,
                                                  therapySettings: .initial,
                                                  prescriberTermsAccepted: true,
                                                  state: .submitted)
        let revision = TPrescription.Revision(revisionId: 0,
                                              attributes: attributes,
                                              createdTime: dateFormatter.date(from: "2021-04-28T20:19:30.841Z"),
                                              createdUserId: "42cb2e2f-b0e7-4168-a30f-a2738777027a")
        return TPrescription(id: "6089c35220398b38a71f2103",
                             patientUserId: "dd8373e3-992e-4801-a17e-08b49b4f3ade",
                             state: .claimed,
                             latestRevision: revision,
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

fileprivate extension Array where Element == TPrescription.Attributes.InitialSettings.BasalRateStart {
    var basalRateSchedule: BasalRateSchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return BasalRateSchedule(dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.BasalRateStart {
    var repeatingScheduleValue: RepeatingScheduleValue<Double>? {
        guard let start = start, let rate = rate else {
            return nil
        }

        return RepeatingScheduleValue(startTime: start, value: rate)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.BloodGlucoseTarget {
    var doubleRange: DoubleRange? {
        guard let low = low, let high = high, target == nil, range == nil else {
            return nil
        }

        return DoubleRange(minValue: low, maxValue: high)
    }
}

fileprivate extension Array where Element == TPrescription.Attributes.InitialSettings.BloodGlucoseStartTarget {
    func glucoseTargetRangeSchedule(in unit: HKUnit) -> GlucoseRangeSchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return GlucoseRangeSchedule(unit: unit, dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.BloodGlucoseStartTarget {
    var repeatingScheduleValue: RepeatingScheduleValue<DoubleRange>? {
        guard let start = start, let low = low, let high = high, target == nil, range == nil else {
            return nil
        }

        return RepeatingScheduleValue(startTime: start, value: DoubleRange(minValue: low, maxValue: high))
    }
}

fileprivate extension Array where Element == TPrescription.Attributes.InitialSettings.CarbohydrateRatioStart {
    var carbRatioSchedule: CarbRatioSchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return CarbRatioSchedule(unit: .gram(), dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.CarbohydrateRatioStart {
    var repeatingScheduleValue: RepeatingScheduleValue<Double>? {
        guard let start = start, let amount = amount else {
            return nil
        }

        return RepeatingScheduleValue(startTime: start, value: amount)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.InsulinModelType {
    var defaultRapidActingModel: ExponentialInsulinModelPreset? {
        switch self {
        case .rapidAdult:
            return ExponentialInsulinModelPreset.rapidActingAdult
        case .rapidChild:
            return ExponentialInsulinModelPreset.rapidActingChild
        default:
            return nil
        }
    }
}

fileprivate extension Array where Element == TPrescription.Attributes.InitialSettings.InsulinSensitivityStart {
    func insulinSensitivitySchedule(in unit: HKUnit) -> InsulinSensitivitySchedule? {
        let dailyItems = compactMap { $0.repeatingScheduleValue }
        guard !dailyItems.isEmpty else {
            return nil
        }

        return InsulinSensitivitySchedule(unit: unit, dailyItems: dailyItems)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.InsulinSensitivityStart {
    var repeatingScheduleValue: RepeatingScheduleValue<Double>? {
        guard let start = start, let amount = amount else {
            return nil
        }

        return RepeatingScheduleValue(startTime: start, value: amount)
    }
}

fileprivate extension TPrescription.Attributes.InitialSettings.BasalRateMaximum {
    var maximumBasalRatePerHour: Double? { value }
}

fileprivate extension TPrescription.Attributes.InitialSettings.BolusAmountMaximum {
    var maximumBolus: Double? { value }
}
