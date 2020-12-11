//
//  HomeBuilder.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs

protocol HomeDependency: Dependency {}

final class HomeComponent: Component<HomeDependency> {
    fileprivate var useCase: HomeSearchImageUseCaseProtocol {
        return self.container.resolve(HomeSearchImageUseCaseProtocol.self)!
    }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)

        let viewController = HomeViewController()
        let alertService: AlertService = AlertService()

        let interactor = HomeInteractor(presenter: viewController,
                                        imageSearchUseCase: component.useCase, alertService: alertService)

        let detailBuilder = DetailBuilder(dependency: component)

        interactor.listener = listener
        
        return HomeRouter(interactor: interactor, viewController: viewController,
                          detailBuilder: detailBuilder)
    }
}
