//
//  ReplaceableChild.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import UIKit

import RIBs

protocol ReplaceableChild: class {
    var targetChildController: ViewControllable? { get set }
    func replaceChild(viewController: ViewControllable?)
}

extension ReplaceableChild where Self: UIViewController {

    private func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        self.view.addConstraints(child.view.constraints)
        self.didMove(toParent: self)
    }

    private func remove(_ child: UIViewController) {
        self.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

    func replaceChild(viewController: ViewControllable?) {
        let oldViewController = self.targetChildController?.uiviewController

        defer {
            if let oldViewController = oldViewController{
                self.remove(oldViewController)
            }
        }

        self.targetChildController = viewController
        if let viewController = viewController?.uiviewController {
            self.add(viewController)
        }
    }
}
