//
//  OnboardingSection.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

/// The onboarding sections, in order of progression
enum OnboardingSection: String, CaseIterable, Codable, Equatable {
    case welcome
    case introduction
    case howTheAppWorks
    case aDayInTheLife
    case yourSettings
    case yourDevices
    case getLooping

    enum State: Equatable {
        case completed
        case available
        case unavailable
    }

    enum Progress: String, Codable, Equatable {
        case started
        case completed
    }
}

struct OnboardingSectionProgress: RawRepresentable, Codable, Equatable {
    typealias RawValue = [String: Any]

    let section: OnboardingSection
    let progress: OnboardingSection.Progress
    let date: Date
    let timeZone: String

    init(_ section: OnboardingSection, _ progress: OnboardingSection.Progress) {
        self.section = section
        self.progress = progress
        self.date = Date()
        self.timeZone = TimeZone.current.identifier
    }

    init?(rawValue: RawValue) {
        guard let rawSection = rawValue["section"] as? OnboardingSection.RawValue,
              let section = OnboardingSection(rawValue: rawSection),
              let rawProgress = rawValue["progress"] as? OnboardingSection.Progress.RawValue,
              let progress = OnboardingSection.Progress(rawValue: rawProgress),
              let date = rawValue["date"] as? Date,
              let timeZone = rawValue["timeZone"] as? String else {
            return nil
        }

        self.section = section
        self.progress = progress
        self.date = date
        self.timeZone = timeZone
    }

    var rawValue: RawValue {
        return [
            "section": section.rawValue,
            "progress": progress.rawValue,
            "date": date,
            "timeZone": timeZone
        ]
    }
}

struct OnboardingSectionProgression: RawRepresentable, Codable, Equatable {
    typealias RawValue = [OnboardingSectionProgress.RawValue]

    private var progression: [OnboardingSectionProgress]

    init() {
        self.progression = []
    }

    init?(rawValue: RawValue) {
        self.progression = rawValue.compactMap { OnboardingSectionProgress(rawValue: $0) }
    }

    var rawValue: RawValue {
        return progression.map { $0.rawValue }
    }

    mutating func startSection(_ section: OnboardingSection) {
        precondition(hasCompletedAllPreviousSections(section))
        progression.append(OnboardingSectionProgress(section, .started))
    }

    mutating func completeSection(_ section: OnboardingSection) {
        precondition(hasStartedSection(section))
        progression.append(OnboardingSectionProgress(section, .completed))
    }

    func stateForSection(_ section: OnboardingSection) -> OnboardingSection.State {
        if hasCompletedSection(section) {
            return .completed
        } else if hasCompletedAllPreviousSections(section) {
            return .available
        } else {
            return .unavailable
        }
    }

    func isAvailableSection(_ section: OnboardingSection) -> Bool { hasCompletedAllPreviousSections(section) && !hasCompletedSection(section) }

    func hasStartedSection(_ section: OnboardingSection) -> Bool { progression.contains { $0.section == section && $0.progress == .started } }

    func hasCompletedSection(_ section: OnboardingSection) -> Bool { progression.contains { $0.section == section && $0.progress == .completed } }

    var hasCompletedAllSections: Bool { OnboardingSection.allCases.allSatisfy { hasCompletedSection($0) } }

    private func hasCompletedAllPreviousSections(_ section: OnboardingSection) -> Bool { OnboardingSection.allCases.prefix(while: { $0 != section }).allSatisfy({ hasCompletedSection($0) }) }
}
