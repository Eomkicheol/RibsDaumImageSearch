//
//  HomeViewController.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import UIKit

import RIBs
import RxSwift
import SnapKit
import Then
import ReusableKit
import ReactorKit
import RxDataSources
import RxSwiftExt

enum HomeViewAction {
    case searchImage(String)
    case showKeyboard
    case selectedItem(Int)
    case loadMore
}

typealias HomeViewReactor = (
    state: Observable<HomeState>,
    currentState: HomeState,
    action: ActionSubject<HomeViewAction>
)

protocol HomePresentableListener: class {
    var state: Observable<HomeState> { get }
    var currentState: HomeState { get }
    var action: ActionSubject<HomeViewAction> { get }
}

final class HomeViewController: BaseViewController, HomePresentable, HomeViewControllable {
    
    var targetViewController: ViewControllable?
    var animationInProgress: Bool = false


    weak var listener: HomePresentableListener?

    typealias UserListDataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>

    enum Reusable {
        static let imageCell = ReusableCell<SearchImageCollectionViewCell>()
        static let emptyCell = ReusableCell<EmptyCollectionViewCell>()
    }

    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    private lazy var dataSource = self.createDataSource()

    let searchBar = UISearchBar().then {
        $0.setImage(UIImage(), for: .search, state: .normal)
        $0.placeholder = "검색어를 입력해 주세요."
    }

    lazy var searchBaContainerView = SearchBarContainerView(customSearchBar: searchBar).then {
        $0.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
    }

    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: self.flowLayout).then { view in
                                                self.flowLayout.scrollDirection = .vertical
                                                self.flowLayout.minimumInteritemSpacing = 0.0

                                                view.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 243 / 255, alpha: 1.0)
                                                view.contentInset.bottom = 80
                                            
                                                view.showsHorizontalScrollIndicator = false
                                                view.keyboardDismissMode = .onDrag
                                                view.contentInsetAdjustmentBehavior = .never
                                                view.register(Reusable.imageCell)
                                                view.register(Reusable.emptyCell)
                                               }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()

        guard let reactor = configureReactor(listener: listener) else { return }

        // actions
        self.searchImageAction(reactor: reactor)
        self.showSearchBarTextKeyboardAction(reactor: reactor)
        self.selectedSearchImage(reactor: reactor)
        self.loadMoreSearchImage(reactor: reactor)

        //state
        self.searchImageStateBind(reactor: reactor)
        self.loadingIndicatorStateBind(reactor: reactor)
        self.showKeyboardStateBind(reactor: reactor)
        self.bindCollectionViewDelegate(reactor: reactor)
    }

    
    override func configureUI() {
        super.configureUI()

        [collectionView].forEach {
            self.view.addSubview($0)
        }
    }

    override func setupConstraints() {
        super.setupConstraints()

        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    private func configureNavigationBar() {
        self.navigationItem.titleView = searchBaContainerView
    }

    private func configureReactor(listener: HomePresentableListener?) -> HomeViewReactor? {

        guard let action = self.listener?.action,
              let state = self.listener?.state,
              let currentState = self.listener?.currentState
        else { return nil }

        let reactor: HomeViewReactor = (state, currentState, action)

        return reactor
    }
}

// Action
extension HomeViewController {
    private func searchImageAction(reactor: HomeViewReactor) {
        self.searchBar.rx.text.changed
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filterNil()
            .map { keyword -> HomeViewAction in
                return HomeViewAction.searchImage(keyword)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    private func showSearchBarTextKeyboardAction(reactor: HomeViewReactor) {
        self.rx.viewDidAppear
            .take(1)
            .map { _ in HomeViewAction.showKeyboard }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    private func selectedSearchImage(reactor: HomeViewReactor) {
        self.collectionView.rx.itemSelected
            .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
            .map { row -> HomeViewAction in
                return HomeViewAction.selectedItem(row.row)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

    }
    
    private func loadMoreSearchImage(reactor: HomeViewReactor) {
        self.collectionView.rx.reachedBottom(offset: 10)
            .map { _ in HomeViewAction.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension HomeViewController {
    fileprivate func createDataSource() -> RxCollectionViewSectionedAnimatedDataSource<HomeSection> {
        return .init(configureCell: { dataSource, collectionView, indexPath, sectionItem -> UICollectionViewCell in

            switch sectionItem {
                case .image(let cellReactor):
                    let cell = collectionView.dequeue(Reusable.imageCell, for: indexPath)
                    cell.reactor = cellReactor
                    cell.configure()
                    return cell
                case .empty:
                    let cell = collectionView.dequeue(Reusable.emptyCell, for: indexPath)
                    cell.configure()
                    return cell
            }
        })
    }
}

//bind
extension HomeViewController {
    private func searchImageStateBind(reactor: HomeViewReactor) {
        reactor.state
            .compactMap { $0.sections}
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .do(onNext: {[weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .drive(self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }

    private func loadingIndicatorStateBind(reactor: HomeViewReactor) {
        reactor.state
            .compactMap { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.networking)
            .disposed(by: self.disposeBag)
    }

    private func showKeyboardStateBind(reactor: HomeViewReactor) {
        reactor.state
            .map { $0.showKeyboard }
            .filterNil()
            .asDriver(onErrorJustReturn: ())
            .delay(.milliseconds(5))
            .drive(onNext: {[weak self] _ in
                self?.searchBar.becomeFirstResponder()
            }).disposed(by: self.disposeBag)
    }

    private func bindCollectionViewDelegate(reactor: HomeViewReactor) {
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath] {
            case .image:
                return SearchImageCollectionViewCell.size(width: (collectionView.bounds.width / 3) - 8 - 8)
            default:
                return .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch dataSource[section].identity {
            case .image:
                return 16.0
            case .empty:
                return 0.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch dataSource[section].identity {
            case .image:
                return .init(top: 10, left: 8, bottom: 0, right: 8)
            case .empty:
                return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
