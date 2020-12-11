//
//  SearchImageCollectionViewCell.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher

final class SearchImageCollectionViewCell: BaseCollectionViewCell, ReactorKit.View {

    typealias Reactor = SearchImageCellReactor
    // MARK: Constants
    private enum Constants {
        static let imageHeight: CGFloat = 100
    }

    // MARK: Propertie

    // MARK: UI Properties

    let imageView = UIImageView().then { view in
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
    }


    // MARK: Initializing
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    override func configure() {
        super.configure()
    }

    // MARK: Constraints

    override func configureUI() {
        super.configureUI()

        [imageView].forEach {
            self.contentView.addSubview($0)
        }
    }

    override func setupConstraints() {
        super.setupConstraints()

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    static func size(width: CGFloat) -> CGSize {
        let height: CGFloat = Constants.imageHeight
        return CGSize(width: width, height: height)
    }

    func bind(reactor: Reactor) {
        reactor.state
            .map { $0.documents }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: {[weak self] items in
                if let url = URL(string: items.thumbnailUrl) {
                    self?.imageView.kf.setImage(with: url, options: [.cacheMemoryOnly,
                                                                     .transition(.fade(0.2))])
                }
            })
            .disposed(by: self.disposeBag)

    }
}

