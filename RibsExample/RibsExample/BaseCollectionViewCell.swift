//
//  BaseCollectionViewCell.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {

    private(set) var didSetupConstraints = false

    var disposeBag = DisposeBag()

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Func

    override func updateConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateConstraints()
    }

    func configure() {
        self.setNeedsUpdateConstraints()
    }

    func configureUI() {
        self.contentView.backgroundColor = .white
    }

    func setupConstraints() { }
}
