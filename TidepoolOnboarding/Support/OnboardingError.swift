//
//  OnboardingError.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 5/11/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

enum OnboardingError: LocalizedError {
    case unexpectedState
    case networkFailure
    case authenticationFailure
    case resourceNotFound

    var errorDescription: String? {
        switch self {
        case .unexpectedState:
            return LocalizedString("An unexpected state occurred.", comment: "Error description for an unexpected state.")
        case .networkFailure:
            return LocalizedString("Poor network connection detected. Please check your connectivity and try again.", comment: "Error description for a network failure.")
        case .authenticationFailure:
            return LocalizedString("An authentication error occurred.", comment: "Error description for an authentication failure.")
        case .resourceNotFound:
            return LocalizedString("A network error occurred.", comment: "Error description for a resource not found.")
        }
    }
}
