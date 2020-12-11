//
//  CommonExtensions.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import UIKit

//MAEK: -- AnimatedChangeRootViewController
extension UIWindow {

    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map{ $0 as? UIWindowScene }
            .compactMap { $0}
            .first?.windows
            .filter { $0.isKeyWindow }.first ?? UIWindow()
    }


    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {

        guard let view = keyWindow else { return }

        if animated {
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                view.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                if completion != nil {
                    completion!()
                }
            })
        } else {
            view.rootViewController = rootViewController
        }
    }
}

// MARK: - Dictionary
extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (key, value) in dict {
            updateValue(value, forKey: key)
        }
    }
}

// MARK: - 최상위 뷰컨
extension UIApplication {
    static func topViewController(ViewController: UIViewController?) -> UIViewController? {

        if let tabBarViewController = ViewController as? UITabBarController {
            if let vc = tabBarViewController.selectedViewController {
                return topViewController(ViewController: vc)
            }
        }

        if let navigationViewController = ViewController as? UINavigationController {
            if let vc = navigationViewController.visibleViewController {
                return topViewController(ViewController: vc)
            }
        }

        if let presentedViewController = ViewController?.presentedViewController {
            return topViewController(ViewController: presentedViewController)
        }
        
        return ViewController
    }
}
