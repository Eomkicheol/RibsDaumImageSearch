//
//  BaseAlertAction.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/02.
//

import UIKit

enum BaseAlertAction: AlertActionType {
    case ok
    case cancel

    var title: String? {
        switch self {
            case .ok: return "확인"
            case .cancel: return "취소"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
            case .ok: return .default
            case .cancel: return .default
        }
    }
}

