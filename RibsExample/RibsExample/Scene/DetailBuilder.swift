//
//  DetailBuilder.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/03.
//

import RIBs

protocol DetailDependency: Dependency {}

final class DetailComponent: Component<DetailDependency> {}

// MARK: - Builder

protocol DetailBuildable: Buildable {
    func build(withListener listener: DetailListener, dto: SearchImageDTO) -> DetailRouting
}

final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {

    override init(dependency: DetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: DetailListener, dto: SearchImageDTO) -> DetailRouting {
        
        let viewController = DetailViewController(dto: dto)
        let interactor = DetailInteractor(presenter: viewController)
        
        return DetailRouter(interactor: interactor,
                            viewController: viewController)
    }
}
