//
//  Prescription.swift
//  TidepoolOnboarding
//
//  Created by Anna Quinlan on 6/18/20.
//  Copyright © 2020 Tidepool Project. All rights reserved.
//

import Foundation
import HealthKit
import LoopKit

struct Prescription: LoopKit.Prescription {
    enum CGMType: String {
        case dexcom_g6
    }

    enum PumpType: String {
        case insulet_dash
    }

    let datePrescribed: Date
    let providerName: String
    let cgmType: CGMType
    let pumpType: PumpType
    let therapySettings: TherapySettings

    init(datePrescribed: Date, providerName: String, cgmType: CGMType, pumpType: PumpType, therapySettings: TherapySettings) {
        self.datePrescribed = datePrescribed
        self.providerName = providerName
        self.cgmType = cgmType
        self.pumpType = pumpType
        self.therapySettings = therapySettings
    }
}

extension Prescription: RawRepresentable {
    typealias RawValue = [String: Any]

    init?(rawValue: RawValue) {
        guard let datePrescribed = rawValue["datePrescribed"] as? Date,
              let providerName = rawValue["providerName"] as? String,
              let rawCGMType = rawValue["cgmType"] as? CGMType.RawValue,
              let cgmType = CGMType(rawValue: rawCGMType),
              let rawPumpType = rawValue["pumpType"] as? PumpType.RawValue,
              let pumpType = PumpType(rawValue: rawPumpType),
              let rawTherapySettings = rawValue["therapySettings"] as? TherapySettings.RawValue,
              let therapySettings = TherapySettings(rawValue: rawTherapySettings) else {
            return nil
        }

        self.datePrescribed = datePrescribed
        self.providerName = providerName
        self.cgmType = cgmType
        self.pumpType = pumpType
        self.therapySettings = therapySettings
    }

    var rawValue: RawValue {
        return [
            "datePrescribed": datePrescribed,
            "providerName": providerName,
            "cgmType": cgmType.rawValue,
            "pumpType": pumpType.rawValue,
            "therapySettings": therapySettings.rawValue
        ]
    }
}

extension Prescription {
    static var mock: Prescription {
        return Prescription(datePrescribed: Date(),
                            providerName: "Sally Seastar",
                            cgmType: .dexcom_g6,
                            pumpType: .insulet_dash,
                            therapySettings: .mockTherapySettings)
    }
}
