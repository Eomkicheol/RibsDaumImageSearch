//
//  AlertServiceType.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/02.
//

import UIKit

import RxSwift
import RxCocoa

protocol AlertServiceType: class {
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

protocol AlertActionType {
    var title: String? { get }
    var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
        return .default
    }
}

