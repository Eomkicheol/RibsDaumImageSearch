//
//  RootBuilder.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency> {
    let rootViewController: RootViewController

    init(dependency: RootDependency, rootViewController: RootViewController) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler)
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
        let viewController = RootViewController()
        
        let component = RootComponent(dependency: self.dependency, rootViewController: viewController)
        let interactor = RootInteractor(presenter: viewController)

        let homeBuilder = HomeBuilder(dependency: component)

        let router = RootRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder
        )

        return (router, interactor)
    }
}
