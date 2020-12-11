//
//  AlertService.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/02.
//

import UIKit

import RxSwift
import RxCocoa

final class AlertService: AlertServiceType {

    func show<Action>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action> where Action: AlertActionType {
        return Observable.create { observer -> Disposable in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            let messageAttributedString = NSAttributedString(string: message ?? "", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1.0)
            ])

            let titleAttributedString = NSAttributedString(string: title ?? "", attributes: [
                                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                                                            NSAttributedString.Key.foregroundColor: UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1.0)])


            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }

                alert.addAction(alertAction)
            }

            alert.setValue(titleAttributedString, forKey: "attributedTitle")
            alert.setValue(messageAttributedString, forKey: "attributedMessage")

            let keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map{ $0 as? UIWindowScene }
                    .compactMap { $0}
                    .first?.windows
                    .filter { $0.isKeyWindow }.first

            if let topView = UIApplication.topViewController(ViewController: keyWindow?.rootViewController) {
                DispatchQueue.main.async {
                    topView.present(alert, animated: true, completion: nil)
                }
            }

            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
