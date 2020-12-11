//
//  RootViewController.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    var targetChildController: ViewControllable?
    weak var listener: RootPresentableListener?
}
