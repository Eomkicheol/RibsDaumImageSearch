//
//  DetailViewController.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/03.
//

import UIKit

import RIBs
import RxSwift
import ReactorKit


enum DetailViewAction {
    case configureImage(dto: SearchImageDTO)
}

typealias DetailViewReactor = (
    state: Observable<DetailState>,
    currentState: DetailState,
    action: ActionSubject<DetailViewAction>
)

protocol DetailPresentableListener: class {
    var state: Observable<DetailState> { get }
    var currentState: DetailState { get }
    var action: ActionSubject<DetailViewAction> { get }
}

final class DetailViewController: BaseViewController, DetailPresentable, DetailViewControllable {

    weak var listener: DetailPresentableListener?
    
    let dto: SearchImageDTO
    
    let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    let contentView = UIView()
    
    let imageView = CustomImageView()
    
    init(dto: SearchImageDTO) {
        self.dto = dto
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let reactor = configureReactor(listener: listener) else { return }
        
        // actions
        self.configureImageAction(reactor: reactor, dto: self.dto)
        
        //state
        self.configureImageStateBind(reactor: reactor)
    }

    override func configureUI() {
        super.configureUI()
        
        [scrollView].forEach {
            self.view.addSubview($0)
        }
        
        [contentView].forEach {
            self.scrollView.addSubview($0)
        }
        
        [imageView].forEach {
            contentView.addSubview($0)
        }
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(1)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(imageView.snp.width).multipliedBy(self.dto.ratio)
        }
    }
    
    private func configureReactor(listener: DetailPresentableListener?) -> DetailViewReactor? {
        
        guard let action = self.listener?.action,
              let state = self.listener?.state,
              let currentState = self.listener?.currentState
        else { return nil }
        
        let reactor: DetailViewReactor = (state, currentState, action)
        
        return reactor
    }
}

// action
extension DetailViewController {
    private func configureImageAction(reactor: DetailViewReactor, dto: SearchImageDTO) {
        self.rx.viewDidAppear
            .map { _ in DetailViewAction.configureImage(dto: dto) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

// bind
extension DetailViewController {
    private func configureImageStateBind(reactor: DetailViewReactor) {
        reactor.state
            .map { $0.configureImage }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] items in
                self?.imageView.setURL(urlName: items.imageUrl,
                                       dateTime: items.dateTime,
                                       siteName: items.displaySiteName)
            })
            .disposed(by: self.disposeBag)
    }
}
