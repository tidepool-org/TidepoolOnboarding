//
//  NavigationBarAppearance.swift
//  TidepoolOnboarding
//
//  Created by Darin Krauss on 4/8/21.
//  Copyright © 2021 Tidepool Project. All rights reserved.
//

import Combine
import SwiftUI

struct NavigationViewWithNavigationBarAppearance<Content: View>: View {
    private let content: Content
    private let navigationBarAppearance: NavigationBarAppearance
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.navigationBarAppearance = NavigationBarAppearance()
    }
    
    var body: some View {
        NavigationControllerView() {
            content
        }
        .environmentObject(navigationBarAppearance)
    }
}

extension View {
    func navigationBarTranslucent(_ translucent: Bool) -> some View {
        modifier(NavigationBarTranslucent(translucent))
    }

    func navigationBarBackgroundColor(_ backgroundColor: UIColor?) -> some View {
        modifier(NavigationBarBackgroundColor(backgroundColor))
    }
    
    func navigationBarShadowColor(_ shadowColor: UIColor?) -> some View {
        modifier(NavigationBarShadowColor(shadowColor))
    }
}

fileprivate class NavigationBarAppearance: ObservableObject {
    @Published var translucent: Bool = true
    @Published var backgroundColor: UIColor?
    @Published var shadowColor: UIColor?
}

fileprivate struct NavigationBarTranslucent: ViewModifier {
    @EnvironmentObject var navigationBarAppearance: NavigationBarAppearance

    private let translucent: Bool

    init(_ translucent: Bool) {
        self.translucent = translucent
    }

    func body(content: Content) -> some View {
        content
            .onAppear { navigationBarAppearance.translucent = translucent }
    }
}

fileprivate struct NavigationBarBackgroundColor: ViewModifier {
    @EnvironmentObject var navigationBarAppearance: NavigationBarAppearance
    
    private let backgroundColor: UIColor?
    
    init(_ backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear { navigationBarAppearance.backgroundColor = backgroundColor }
    }
}

fileprivate struct NavigationBarShadowColor: ViewModifier {
    @EnvironmentObject var navigationBarAppearance: NavigationBarAppearance
    
    private let shadowColor: UIColor?
    
    init(_ shadowColor: UIColor?) {
        self.shadowColor = shadowColor
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear { navigationBarAppearance.shadowColor = shadowColor }
    }
}

fileprivate struct NavigationControllerView<Content: View>: UIViewControllerRepresentable {
    @EnvironmentObject var navigationBarAppearance: NavigationBarAppearance
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        return NavigationController(content: content, navigationBarAppearance: navigationBarAppearance)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

fileprivate class NavigationController<Content: View>: UINavigationController {
    private let content: Content
    private let navigationBarAppearance: NavigationBarAppearance
    
    private lazy var cancellables = Set<AnyCancellable>()
    
    init(content: Content, navigationBarAppearance: NavigationBarAppearance) {
        self.content = content
        self.navigationBarAppearance = navigationBarAppearance
        
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: UIToolbar.self)
        
        navigationBarAppearance.$translucent
            .sink { [weak self] translucent in self?.navigationBar.isTranslucent = translucent }
            .store(in: &cancellables)
        navigationBarAppearance.$backgroundColor
            .sink { [weak self] backgroundColor in self?.navigationBar.barTintColor = backgroundColor }
            .store(in: &cancellables)
        navigationBarAppearance.$shadowColor
            .sink { [weak self] shadowColor in self?.navigationBar.shadowImage = shadowColor?.image() }
            .store(in: &cancellables)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setViewControllers([UIHostingController(rootView: content)], animated: animated)
    }
}
