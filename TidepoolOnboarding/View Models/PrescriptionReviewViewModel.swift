//
//  PrescriptionCodeEntryViewModel.swift
//  TidepoolOnboarding
//
//  Created by Anna Quinlan on 6/22/20.
//  Copyright © 2020 Tidepool Project. All rights reserved.
//

import Foundation
import HealthKit
import LoopKit
import LoopKitUI

class PrescriptionReviewViewModel: ObservableObject {
    // MARK: Navigation
    var didFinishStep: (() -> Void)
    var didCancel: (() -> Void)?
    
    // MARK: State
    @Published var shouldDisplayError = false
    
    // MARK: Prescription Information
    var prescription: MockPrescription?
    let prescriptionCodeLength = 6

    // MARK: Date Picker Information
    let validDateRange = Calendar.current.date(byAdding: .year, value: -130, to: Date())!...Date()
    // Default to 35 years ago for birthdays, which is what the Apple Health app does
    let pickerStartDate = Calendar.current.date(byAdding: .year, value: -35, to: Date())!
    let placeholderFieldText = LocalizedString("Select birthdate", comment: "Prompt to select birthdate with picker")
    
    init(finishedStepHandler: @escaping () -> Void = { }) {
        self.didFinishStep = finishedStepHandler
    }
    
    func entryNavigation(success: Bool) {
        if success {
            shouldDisplayError = false
            didFinishStep()
        } else {
           shouldDisplayError = true
        }
    }
    
    func validate(_ prescriptionCode: String, _ birthday: Date) -> Bool {
        return prescriptionCode.count == prescriptionCodeLength && prescriptionCode.isAlphanumeric() && validDateRange.contains(birthday)
    }
    
    func loadPrescriptionFromCode(prescriptionCode: String, birthday: Date) {
        guard validate(prescriptionCode, birthday) else {
            self.entryNavigation(success: false)
            return
        }

        // TODO: call function to properly query the backend; if prescription couldn't be retrieved, raise unableToRetreivePrescription error
        MockPrescriptionManager().getPrescriptionData { result in
            switch result {
            case .failure:
                fatalError("Mock prescription manager should always return a prescription")
            case .success(let prescription):
                self.prescription = prescription
                self.entryNavigation(success: true)
            }
        }
    }
}

extension String {
    fileprivate func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}