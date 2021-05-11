//
//  YourSettingsViews.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 3/9/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKitUI

struct YourSettingsNavigationButton: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    var body: some View {
        OnboardingSectionNavigationButton(section: .yourSettings, destination: NavigationViewWithNavigationBarAppearance { destination })
            .accessibilityIdentifier("button_your_settings")
    }

    @ViewBuilder
    private var destination: some View {
        if onboardingViewModel.tidepoolService?.isOnboarded != true {
            YourSettingsTidepoolServiceOnboardingView(destination: nextDestination)
        } else {
            nextDestination
        }
    }

    @ViewBuilder
    private var nextDestination: some View {
        if onboardingViewModel.prescription == nil {
            YourSettingsPrescriptionAccessCodeEntryView()
        } else {
            YourSettingsReviewYourSettingsView()
        }
    }
}

// MARK: - YourSettingsTidepoolServiceOnboardingView

// TODO: PLACEHOLDER - Will be replaced with final view(s) once delivered by product and design
fileprivate struct YourSettingsTidepoolServiceOnboardingView<Destination: View>: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var alertMessage: String?
    @State private var isAlertPresented = false

    @State private var sheetViewController: ServiceViewController?
    @State private var isSheetPresented = false
    @State private var onSheetDismiss: (() -> Void)?

    let destination: Destination

    var body: some View {
        OnboardingSectionPageView(section: .yourSettings, destination: destination) {
            PageHeader(title: LocalizedString("Your Tidepool Account", comment: "Onboarding, Your Settings section, view 1, title"))
            Paragraph(LocalizedString("If you already have a Tidepool acccount you can Sign In.", comment: "Onboarding, Your Settings section, view 1, paragraph"))
        }
        .backButtonHidden(true)
        .nextButtonTitle(LocalizedString("Sign In", comment: "Onboarding, Your Settings section, view 1, sign up button, title"))
        .nextButtonAction(nextButtonAction)
        .alert(isPresented: $isAlertPresented) { alert }
        .sheet(isPresented: $isSheetPresented, onDismiss: onSheetDismiss) { sheet }
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        switch onboardingViewModel.onboardTidepoolService() {
        case .failure(let error):
            self.alertMessage = error.localizedDescription
            self.isAlertPresented = true
        case .success(let success):
            switch success {
            case .userInteractionRequired(let viewController):
                self.sheetViewController = viewController
                self.isSheetPresented = true
                self.onSheetDismiss = { completion(onboardingViewModel.tidepoolService?.isOnboarded == true) }
            case .createdAndOnboarded:
                completion(onboardingViewModel.tidepoolService?.isOnboarded == true)
            }
        }
    }

    private var alert: Alert {
        Alert(title: Text(LocalizedString("Error", comment: "Title of general error alert")), message: Text(alertMessage!))
    }

    private var sheet: some View {
        TidepoolServiceView(sheetViewController!)
            .presentation(isModal: true)
            .environment(\.dismiss, { isSheetPresented = false })
    }
}

// MARK: - YourSettingsPrescriptionAccessCodeEntryView

struct YourSettingsPrescriptionAccessCodeEntryView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var accessCode = ""
    @State private var birthday = Date().years(ago: birthdayYearsDefault)
    @State private var error: Error?

    @State private var hasBirthdayPickerShown = false
    @State private var isBirthdayPickerVisible = false
    @State private var isNextButtonActing = false

    var body: some View {
        OnboardingSectionPageView(section: .yourSettings, destination: YourSettingsReviewYourSettingsView()) {
            PageHeader(title: LocalizedString("Your Settings", comment: "Onboarding, Your Settings section, view 2, title"))
            Segment {
                segment1
                    .padding(.bottom)
                segment2
                    .padding(.bottom)
                segment3
                errorView
            }
        }
        .backButtonHidden(true)
        .nextButtonTitle(LocalizedString("Submit", comment: "Onboarding, Your Settings section, view 2, next button, title"))
        .nextButtonAction(nextButtonAction)
        .nextButtonDisabled(accessCode.count != accessCodeLength || !hasBirthdayPickerShown || isNextButtonActing)
        .onTapGesture(perform: dismissAccessories)
    }

    private var segment1: some View {
        Segment(header: LocalizedString("What you’ll need", comment: "Onboarding, Your Settings section, view 2, segment 1, header")) {
            Paragraph(LocalizedString("For this next section, you’ll want to have the following:", comment: "Onboarding, Your Settings section, view 2, segment 1, paragraph"))
                .padding(.bottom)
            NumberedBodyTextList(
                LocalizedString("Prescription activation code", comment: "Onboarding, Your Settings section, view 2, segment 1, list, item 1"),
                LocalizedString("Configuration settings for glucose targets and insulin delivery from your healthcare provider", comment: "Onboarding, Your Settings section, view 2, segment 1, list, item 1")
            )
        }
        .headerFont(.headline)
        .headerSpacing(10)
    }

    private var segment2: some View {
        Segment(header: LocalizedString("Enter your 6-digit prescription code", comment: "Onboarding, Your Settings section, view 2, segment 2, header")) {
            Paragraph(LocalizedString("If you have a prescription activation code, please enter it now.", comment: "Onboarding, Your Settings section, view 2, segment 2, paragraph"))
            accessCodeField
        }
        .headerFont(.headline)
        .headerSpacing(10)
    }

    private var segment3: some View {
        Segment(header: LocalizedString("Enter your birthday", comment: "Onboarding, Your Settings section, view 2, segment 3, header")) {
            Paragraph(LocalizedString("In order for us to verify the prescription code, please enter the birthday associated with your Tidepool account.", comment: "Onboarding, Your Settings section, view 2, segment 3, paragraph"))
            birthdayField
        }
        .headerFont(.headline)
        .headerSpacing(10)
    }

    private func dismissAccessories() {
        dismissAccessCodeKeyboard()
        dismissBirthdayPicker()
    }

    private var accessCodeField: some View {
        TextField(LocalizedString("Activation code", comment: "Onboarding, Your Settings section, view 2, segment 2, code, placeholder"), text: $accessCode, onCommit: showBirthdayPicker)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .keyboardType(.asciiCapable)
            .disabled(isNextButtonActing)
            .opacity(isNextButtonActing ? 0.5 : 1.0)
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .overlay(borderOverlay)
            .onChange(of: accessCode, perform: normalizeAccessCode)
            .onTapGesture(perform: dismissBirthdayPicker)
    }

    private func normalizeAccessCode(_ accessCode: String) {
        self.accessCode = accessCode.prefix(accessCodeLength).uppercased()
    }

    private func dismissAccessCodeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private var birthdayField: some View {
        VStack {
            if isBirthdayPickerVisible {
                birthdayPicker
                    .frame(maxWidth: .infinity)
            } else {
                birthdayLabel
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
            }
        }
        .overlay(borderOverlay)
    }

    private var birthdayLabel: some View {
        Button(action: showBirthdayPicker) {
            birthdayText
                .accentColor(.primary)
                .foregroundColor(.accentColor)
        }
        .buttonStyle(BirthdayButtonStyle())
        .disabled(isNextButtonActing)
    }

    @ViewBuilder
    private var birthdayText: some View {
        if hasBirthdayPickerShown {
            Text(Self.birthdayFormatter.string(from: birthday))
        } else {
            Text(LocalizedString("Select birthday", comment: "Onboarding, Your Settings section, view 2, segment 2, birthday, placeholder"))
                .opacity(0.25)
        }
    }

    private static let birthdayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    private var birthdayPicker: some View {
        DatePicker(String(), selection: $birthday, in: Date().years(ago: birthdayYearsMaximum)...Date(), displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .onTapGesture(perform: dismissAccessCodeKeyboard)
    }

    private func showBirthdayPicker() {
        guard !isNextButtonActing else { return }

        dismissAccessCodeKeyboard()

        withAnimation {
            isBirthdayPickerVisible = true
            hasBirthdayPickerShown = true
        }
    }

    private func dismissBirthdayPicker() {
        withAnimation {
            isBirthdayPickerVisible = false
        }
    }

    @ViewBuilder
    private var errorView: some View {
        if let error = error {
            BodyText(error.localizedDescription)
                .foregroundColor(.red)
        } else {
            EmptyView()
        }
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.accentColor, lineWidth: 1)
            .accentColor(.secondary)
            .opacity(0.5)
    }

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        guard !isNextButtonActing else { return }

        dismissAccessories()

        isNextButtonActing = true
        onboardingViewModel.claimPrescription(accessCode: accessCode, birthday: birthday) { error in
            if case .resourceNotFound = error as? OnboardingError {
                self.error = ClaimPrescriptionError.invalidAccessCodeOrBirthday
            } else {
                self.error = error
            }
            completion(error == nil)
            isNextButtonActing = false
        }
    }

    private let accessCodeLength = 6
    private static let birthdayYearsDefault = 35    // Match Apple Health behavior
    private let birthdayYearsMaximum = 130
}

fileprivate struct BirthdayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        BirthdayButton(configuration: configuration)
    }

    private struct BirthdayButton: View {
        @Environment(\.isEnabled) private var isEnabled: Bool

        let configuration: Configuration

        var body: some View {
            HStack {
                configuration.label
                Spacer()
            }
            .background(Color(.systemBackground))
            .opacity(isEnabled ? 1.0 : 0.5)
            .frame(maxWidth: .infinity)
        }
    }
}

fileprivate enum ClaimPrescriptionError: LocalizedError {
    case invalidAccessCodeOrBirthday

    var errorDescription: String? {
        switch self {
        case .invalidAccessCodeOrBirthday:
            return LocalizedString("The activation code and/or birthday entered are incorrect. Please update or contact Tidepool Support.", comment: "Error description for claim prescription invalid access code or birthday")
        }
    }
}

fileprivate extension Date {
    func years(ago years: Int) -> Date { Calendar.current.date(byAdding: .year, value: -years, to: self)! }
}

// MARK: - YourSettingsReviewYourSettingsView

fileprivate struct YourSettingsReviewYourSettingsView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var error: Error?

    @State private var isNextButtonActing = false
    @State private var isErrorAlertPresented = false

    var body: some View {
        OnboardingSectionPageView(section: .yourSettings, destination: YourSettingsTherapySettingsPreviewView()) {
            PageHeader(title: LocalizedString("Review Your Settings", comment: "Onboarding, Your Settings section, view 3, title"))
            Paragraph(LocalizedString("Since your provider included your recommended settings with your prescription, you’ll have a chance to review and confirm each of these settings now.", comment: "Onboarding, Your Settings section, view 3, paragraph 1"))
            Paragraph(LocalizedString("Your prescription contains recommended settings for the devices listed below.", comment: "Onboarding, Your Settings section, view 3, paragraph 2"))
            Callout(title: LocalizedString("Note", comment: "Onboarding, Your Settings section, view 3, callout")) {
                Paragraph(LocalizedString("Tidepool Loop does NOT automatically adjust or recommend changes to your settings.", comment: "Onboarding, Your Settings section, view 3, callout, paragraph 1"))
                    .bold()
                Paragraph(LocalizedString("Work with your healthcare provider to find the right settings for you.", comment: "Onboarding, Your Settings section, view 3, callout, paragraph 2"))
                    .bold()
            }
            pumpView
                .padding()
            cgmView
                .padding()
        }
        .backButtonHidden(true)
        .nextButtonAction(nextButtonAction)
        .nextButtonDisabled(isNextButtonActing)
        .alert(isPresented: $isErrorAlertPresented) { errorAlert }
    }

    private var pumpView: some View {
        deviceView(image: Image(frameworkImage: "dash").renderingMode(.template),
                   title: LocalizedString("Omnipod 5", comment: "Text describing insulin pump name"),
                   description: LocalizedString("Insulin Pump", comment: "Insulin pump label"))
    }

    private var cgmView: some View {
        deviceView(image: Image(frameworkImage: "dexcom"),
                   title: LocalizedString("Dexcom G6", comment: "Text describing CGM name"),
                   description: LocalizedString("Continuous Glucose Monitor", comment: "CGM label"))
    }

    private func deviceView(image: Image, title: String, description: String) -> some View {
        HStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
                .padding(.horizontal)
                .foregroundColor(.accentColor)  // TODO: Remove once image is obtained directly from the device manager
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }

    private static var imageWidth: CGFloat = 48

    private func nextButtonAction(_ completion: @escaping (Bool) -> Void) {
        guard !isNextButtonActing else { return }

        isNextButtonActing = true
        onboardingViewModel.getPrescriberProfile() { error in
            if let error = error {
                self.error = error
                self.isErrorAlertPresented = true
            }
            completion(error == nil)
            isNextButtonActing = false
        }
    }

    private var errorAlert: Alert {
        Alert(title: Text(LocalizedString("Error", comment: "Title of general error alert")),
              message: Text(error?.localizedDescription ?? LocalizedString("An unknown error occurred.", comment: "Message of an unknown error")))
    }
}

// MARK: - Therapy Settings Wrapper Views

fileprivate struct YourSettingsTherapySettingsPreviewView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body: some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            TherapySettingsView(mode: .acceptanceFlow,
                                viewModel: onboardingViewModel.initialTherapySettingsViewModel,
                                actionButton: TherapySettingsView.ActionButton(localizedString: LocalizedString("Continue", comment: "Your Settings therapy settings preview next button title"),
                                                                               action: { isDestinationActive = true }))
            NavigationLink(destination: YourSettingsSuspendThresholdInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .editMode(true)
    }
}

fileprivate struct YourSettingsSuspendThresholdInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            SuspendThresholdInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsSuspendThresholdEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsSuspendThresholdEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            SuspendThresholdEditor(mode: .acceptanceFlow,
                                   therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                   didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsCorrectionRangeInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .editMode(true)
    }
}

fileprivate struct YourSettingsCorrectionRangeInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CorrectionRangeInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsCorrectionRangeScheduleEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsCorrectionRangeScheduleEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CorrectionRangeScheduleEditor(mode: .acceptanceFlow,
                                          therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                          didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsPreMealCorrectionRangeOverrideInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .backButtonHidden(true)
        .closeButtonHidden(true)
        .editMode(true)
    }
}

fileprivate struct YourSettingsPreMealCorrectionRangeOverrideInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CorrectionRangeOverrideInformationView(preset: .preMeal, onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsPreMealCorrectionRangeOverridesEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsPreMealCorrectionRangeOverridesEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CorrectionRangeOverridesEditor(mode: .acceptanceFlow,
                                           therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel, preset: .preMeal,
                                           didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsWorkoutCorrectionRangeOverrideInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .editMode(true)
    }
}

fileprivate struct YourSettingsWorkoutCorrectionRangeOverrideInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CorrectionRangeOverrideInformationView(preset: .workout, onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsWorkoutCorrectionRangeOverridesEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsWorkoutCorrectionRangeOverridesEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CorrectionRangeOverridesEditor(mode: .acceptanceFlow,
                                           therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel, preset: .workout,
                                           didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsCarbRatioInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .editMode(true)
    }
}

fileprivate struct YourSettingsCarbRatioInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CarbRatioInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsCarbRatioScheduleEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsCarbRatioScheduleEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            CarbRatioScheduleEditor(mode: .acceptanceFlow,
                                    therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                    didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsBasalRatesInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .backButtonHidden(true)
        .closeButtonHidden(true)
        .editMode(true)
    }
}

fileprivate struct YourSettingsBasalRatesInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            BasalRatesInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsBasalRateScheduleEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsBasalRateScheduleEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            BasalRateScheduleEditor(mode: .acceptanceFlow,
                                    therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                    didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsDeliveryLimitsInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .backButtonHidden(true)
        .closeButtonHidden(true)
        .editMode(true)
    }
}

fileprivate struct YourSettingsDeliveryLimitsInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            DeliveryLimitsInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsDeliveryLimitsEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsDeliveryLimitsEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            DeliveryLimitsEditor(mode: .acceptanceFlow,
                                 therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                 didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsInsulinModelInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .editMode(true)
    }
}

fileprivate struct YourSettingsInsulinModelInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            InsulinModelInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsInsulinModelSelection(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsInsulinModelSelection: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.chartColorPalette) var chartColorPalette

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            InsulinModelSelection(mode: .acceptanceFlow,
                                  therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                  chartColors: chartColorPalette,
                                  didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsInsulinSensitivityInformationView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .editMode(true)
    }
}

fileprivate struct YourSettingsInsulinSensitivityInformationView: View {
    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            InsulinSensitivityInformationView(onExit: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsInsulinSensitivityScheduleEditor(), isActive: $isDestinationActive) { EmptyView() }
        }
    }
}

fileprivate struct YourSettingsInsulinSensitivityScheduleEditor: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            InsulinSensitivityScheduleEditor(mode: .acceptanceFlow,
                                             therapySettingsViewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                             didSave: { isDestinationActive = true })
            NavigationLink(destination: YourSettingsTherapySettingsReviewView(), isActive: $isDestinationActive) { EmptyView() }
        }
        .backButtonHidden(true)
        .closeButtonHidden(true)
        .editMode(true)
    }
}

fileprivate struct YourSettingsTherapySettingsReviewView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.complete) var complete

    @State private var isDestinationActive = false

    var body : some View {
        OnboardingSectionWrapperView(section: .yourSettings) {
            TherapySettingsView(mode: .acceptanceFlow,
                                viewModel: onboardingViewModel.currentTherapySettingsViewModel,
                                actionButton: TherapySettingsView.ActionButton(localizedString: LocalizedString("Save Settings", comment: "Your Settings therapy settings review next button title"),
                                                                               action: complete))
        }
        .editMode(true)
    }
}

// MARK: - YourSettingsViews_Previews

struct YourSettingsViews_Previews: PreviewProvider {
    static var onboardingViewModel: OnboardingViewModel = {
        let onboardingViewModel = OnboardingViewModel.preview
        onboardingViewModel.skipUntilSection(.yourSettings)
        return onboardingViewModel
    }()

    static var displayGlucoseUnitObservable: DisplayGlucoseUnitObservable = {
        return DisplayGlucoseUnitObservable.preview
    }()

    static var previews: some View {
        ContentPreviewWithBackground {
            YourSettingsNavigationButton()
                .environmentObject(onboardingViewModel)
                .environmentObject(displayGlucoseUnitObservable)
        }
    }
}
