//
//  OnboardingSectionPagesView.swift
//  TidepoolOnboardingKitUI
//
//  Created by Darin Krauss on 3/4/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import SwiftUI

struct OnboardingPage {
    let title: String
    let view: AnyView

    init<T: View>(title: String, view: T) {
        self.title = title
        self.view = AnyView(view)
    }
}

struct OnboardingSectionPages {
    let section: OnboardingSection
    let pages: [OnboardingPage]

    init(section: OnboardingSection, pages: [OnboardingPage]) {
        self.section = section
        self.pages = pages
    }

    var count: Int { pages.count }

    func title(for pageNumber: Int) -> String { pages[pageNumber - 1].title }
    func view(for pageNumber: Int) -> AnyView { pages[pageNumber - 1].view }
}

struct OnboardingSectionPagesView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.complete) var complete
    @Environment(\.dismiss) var dismiss

    @State private var isCloseAlertPresented = false

    private let sectionPages: OnboardingSectionPages
    private let pageNumber: Int

    init(sectionPages: OnboardingSectionPages, pageNumber: Int = 1) {
        self.sectionPages = sectionPages
        self.pageNumber = pageNumber
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        title
                        pager
                        Divider()
                        page
                        Spacer()
                        continueButton
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .alert(isPresented: $isCloseAlertPresented) { closeAlert }
        .navigationBarTitle(Text(onboardingViewModel.titleForSection(sectionPages.section)), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: closeButton)
    }

    private var title: some View {
        Text(sectionPages.title(for: pageNumber))
            .font(.largeTitle)
            .bold()
            .accessibilityAddTraits(.isHeader)
    }

    private var pager: some View {
        Text(pagerTitle)
            .font(.subheadline)
            .accentColor(.secondary)
            .foregroundColor(.accentColor)
    }

    private var page: some View {
        sectionPages.view(for: pageNumber)
    }

    private var pagerTitle: String { String(format: LocalizedString("%d of %d", comment: "Onboarding pager title"), pageNumber, sectionPages.count) }

    @ViewBuilder
    private var continueButton: some View {
        if let destination = nextSequenceView {
            NavigationButton(title: continueButtonTitle, destination: destination)
                .accessibilityIdentifier("button_continue")
        } else {
            ActionButton(title: continueButtonTitle, action: complete)
                .accessibilityIdentifier("button_continue")
        }
    }

    private var continueButtonTitle: String { LocalizedString("Continue", comment: "Onboarding continue button") }

    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 20)
                Text(backButtonTitle)
                    .fontWeight(.regular)
            }
            .offset(x: -6, y: 0)
        }
        .accessibilityElement()
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(backButtonTitle)
        .accessibilityIdentifier("button_back")
    }

    private var backButtonTitle: String { LocalizedString("Back", comment: "Back navigation button of an onboarding section") }

    private var closeButton: some View {
        Button(action: { isCloseAlertPresented = true }) {
            Text(closeButtonTitle)
                .fontWeight(.regular)
        }
        .accessibilityElement()
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(closeButtonTitle)
        .accessibilityIdentifier("button_close")
    }

    private var closeButtonTitle: String { LocalizedString("Close", comment: "Close navigation button of an onboarding section") }

    private var closeAlert: Alert {
        Alert(title: Text(LocalizedString("Are you sure?", comment: "Alert title confirming close of an onboarding section")),
              message: Text(LocalizedString("You'll have to restart this section.", comment: "Alert message confirming close of an onboarding section")),
              primaryButton: .cancel {
                isCloseAlertPresented = false
              },
              secondaryButton: .destructive(Text(LocalizedString("End", comment: "Alert button confirming close of an onboarding section"))) {
                dismiss()
              })
    }

    private var nextSequenceView: OnboardingSectionPagesView? {
        guard pageNumber < sectionPages.count else { return nil }
        return OnboardingSectionPagesView(sectionPages: sectionPages, pageNumber: pageNumber + 1)
    }
}
