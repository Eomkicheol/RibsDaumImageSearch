//
//  ViewControllableExtensions.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import UIKit

import RIBs

extension ViewControllable {
    func push(viewController: ViewControllable, animated: Bool = true) {
        uiviewController.navigationController?.pushViewController(viewController.uiviewController,
                                                                  animated: animated)
    }

    func pop(animated: Bool = true)  {
        uiviewController.navigationController?.popViewController(animated: animated)
    }

    func pop(to viewController: ViewControllable, animated: Bool = true) {
        uiviewController.navigationController?.popToViewController(viewController.uiviewController,
                                                                   animated: animated)
    }

    func pop(_ viewController: ViewControllable, animated: Bool = true) {
        let hasViewControllerInNvaigationStack = uiviewController
            .navigationController?
            .viewControllers
            .contains
            {
                $0 == viewController.uiviewController
            } ?? false

        guard hasViewControllerInNvaigationStack else { return }
        pop(animated: animated)
    }

    func popToRootViewController(animated: Bool = true) {
        uiviewController.navigationController?.popToRootViewController(animated: animated)
    }

    func present(_ viewController: ViewControllable, animated: Bool = true,
                 completion: (() -> Void)? = nil ) {
        viewController.uiviewController.dismiss(animated: animated,
                                                completion: completion)
    }

    func dismissPresentedViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let presentedViewController = uiviewController.presentedViewController {
            presentedViewController.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
}
