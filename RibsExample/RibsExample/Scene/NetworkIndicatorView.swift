//
//  NetworkIndicatorView.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/02.
//

import UIKit

import SnapKit
import Then

class NetworkIndicatorView: UIView {
    enum Constants {
        static let indicatorBackColor: UIColor = .black
        static let indicatorBackAlpha: CGFloat = 0.6
        static let indicatorBackLayerCornerRadius: CGFloat = 16
    }

    let indicatorBackView = UIView().then {
        $0.backgroundColor = Constants.indicatorBackColor
        $0.alpha = Constants.indicatorBackAlpha
        $0.layer.cornerRadius = Constants.indicatorBackLayerCornerRadius
        $0.clipsToBounds = true
    }

    let indicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.startAnimating()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        indicatorBackView.addSubview(indicator)
        self.addSubview(indicatorBackView)

        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        indicatorBackView.snp.makeConstraints {
            $0.size.equalTo(self.indicator).offset(40)
            $0.center.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

