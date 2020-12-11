//
//  RootRouter.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs

protocol RootInteractable: Interactable, HomeListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable, ReplaceableChild {}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {


    let homeBuilder: HomeBuildable
    var homeView: HomeRouting?

    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         homeBuilder: HomeBuildable) {
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func attachHomeRIB() {
        let home = self.homeBuilder.build(withListener: self.interactor)
        self.attachChild(home)
        let navigationController = UINavigationController(root: home.viewControllable)
        self.viewController.replaceChild(viewController: navigationController)
        self.homeView  = home
    }
}
