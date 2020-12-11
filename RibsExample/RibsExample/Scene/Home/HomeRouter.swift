//
//  HomeRouter.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs

protocol HomeInteractable: Interactable, DetailListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable, ReplaceModalable {}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    let detailBuilder: DetailBuildable
    var detailView: DetailRouting?

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         detailBuilder: DetailBuildable) {

        self.detailBuilder = detailBuilder

        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    func attachImateDetailRibs(dto: SearchImageDTO) {
        let router = self.detailBuilder.build(withListener: self.interactor, dto: dto)
        self.attachChild(router)
        self.viewController.push(viewController: router.viewControllable, animated: true)
    }
}
