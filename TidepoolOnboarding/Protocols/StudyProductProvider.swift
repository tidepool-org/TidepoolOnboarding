//
//  StudyProductProvider.swift
//  TidepoolOnboarding
//
//  Created by Cameron Ingham on 4/3/23.
//

import Foundation

public enum StudyProduct: String, CaseIterable {
    case none
    case studyProduct1
    case studyProduct2
}

public protocol StudyProductProvider {
    var studyProductSelection: StudyProduct { get }
}
