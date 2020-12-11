//
//  UINavigationControllerExtensions.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import UIKit

import RIBs

extension UINavigationController: ViewControllable {
    public var uiviewController: UIViewController { return self }

    public convenience init(root: ViewControllable) {
        self.init(rootViewController: root.uiviewController)
    }
}
