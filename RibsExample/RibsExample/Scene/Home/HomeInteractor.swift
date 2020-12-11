//
//  HomeInteractor.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs
import RxSwift
import RxRelay
import ReactorKit
import RxOptional

protocol HomeRouting: ViewableRouting {
    func attachImateDetailRibs(dto: SearchImageDTO)
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

struct HomeState {
    var sections: [HomeSection] = []
    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    var showKeyboard: Void? = nil
    var isEmpty: Bool? = nil
    var selectedItem: SearchImageDTO = .init()
    
    var totalCount: Int { self.list.total }
    //var hasNext: Bool { self.list.canLoadNext }
    

    fileprivate var list: List<Documents> = .init()
}

protocol HomeListener: class {}

final class HomeInteractor: PresentableInteractor<HomePresentable>,
                            HomeInteractable, HomePresentableListener, Reactor {
    //                            , HomeActionableItem  {
    
    typealias Action = HomeViewAction
    typealias State = HomeState
    
    private enum Constants {
        static let itemCount: Int = 30
    }
    
    enum Mutation {
        case searchImage(List<Documents>)
        case setLoading(Bool)
        case showKeyboard(Void?)
        case selectedItem(SearchImageDTO)
        case appendSearchImage(List<Documents>)
    }
    
    var initialState: State
    
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private let imageSearchUseCase: HomeSearchImageUseCaseProtocol
    private let alertService: AlertServiceType
    private let internalMutationStream = PublishRelay<Observable<Mutation>>()
    
    var searchDTO = PaginationDTO(query: "", page: 1, size: Constants.itemCount)
    
    init(presenter: HomePresentable,
         imageSearchUseCase: HomeSearchImageUseCaseProtocol,
         alertService: AlertServiceType) {
        defer {
            _ = self.state
        }
        self.imageSearchUseCase = imageSearchUseCase
        self.alertService = alertService
        self.initialState = State()
        super.init(presenter: presenter)
        self.presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    //    func routeToDetail() -> Observable<(DetailActionableItem, ())> {
    //        self.router?.routeToDetail()
    //       // let actionable  = self.router?.routeToDetail()
    //        return Observable.just(self, ())
    //    }
}


extension HomeInteractor {
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(mutation, self.internalMutationStream.asObservable().flatMap { $0} )
    }
    
    
    // MARK: mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .searchImage(let title):
                return self.searchImageMutation(title)
            case .showKeyboard:
                return self.showKeyboard()
            case .selectedItem(let row):
                return self.selectedSearchImageItem(row)
            case .loadMore:
                return self.loadMoreMutation()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> HomeState {
        var newState = state
        switch mutation{
            case let .searchImage(item):
                newState = self.searchImageReduce(state: newState, list: item)
            case .setLoading(let isLoading):
                newState.isLoading = isLoading
            case .showKeyboard(let isShow):
                newState.showKeyboard = isShow
            case .selectedItem(let items):
                newState.selectedItem = items
                router?.attachImateDetailRibs(dto: newState.selectedItem)
            case .appendSearchImage(let items):
                newState = self.appendSearchImageReduce(state: newState, list: items)
                
        }
        return newState
    }
    
    
    private func searchImageReduce(state: State, list: List<Documents>) -> State {
        var newState = state
        newState.list = list
        newState.isEmpty = list.items.count <= 0
        
        newState.sections = [
            HomeSection(identity: .image, items: list.items.count > 0 ? list.items.map(SearchImageCellReactor.init).map(HomeSection.Item.image): []),
            HomeSection(identity: .empty, items: list.items.count <= 0 ? [HomeSection.Item.empty]: [])
        ]
        return newState
    }
    
    private func appendSearchImageReduce(state: State, list: List<Documents>) -> State {
        var newState = state
        newState.list.items.append(contentsOf: list.items)
        newState.list.canLoadNext = list.canLoadNext
        newState.list.nextPage = list.nextPage
        newState.sections[0].items.append(contentsOf: list.items.map(SearchImageCellReactor.init).map(HomeSection.Item.image))
        
        return  newState
    }
    
    private func searchImageMutation(_ title: String) -> Observable<Mutation> {
        
        let ob = Observable<String>.just(title)
        
        self.searchDTO.query = title
        
        return ob.flatMap { [weak self] keyword -> Observable<Mutation> in
            guard let self = self else { return .empty()}
            if keyword != "" {
                let searchList = self.notEmptySearchKeyword(keyword)
                
                return Observable.concat([
                    Observable.just(Mutation.setLoading(true)),
                    searchList,
                    Observable.just(Mutation.setLoading(false))
                ])
            } else {
                return Observable.concat([
                    Observable.just(Mutation.setLoading(true)),
                    Observable.just(Mutation.searchImage(.init())),
                    Observable.just(Mutation.setLoading(false))
                ])
            }
        }
    }
    
    private func loadMoreMutation() -> Observable<Mutation> {
        guard !self.currentState.isLoading else { return .empty() }
        guard !self.currentState.isLoadingMore else { return .empty() }
        guard self.currentState.totalCount > 0 else { return .empty()}
       
        let page = (currentState.list.items.count - Constants.itemCount) / Constants.itemCount + 1
        
        self.searchDTO.page = page
        let dto = self.searchDTO
        
        let loadMoreImage = self.imageSearchUseCase.loadMoreSearchImage(dto: dto)
            .map(Mutation.appendSearchImage)
        
        return Observable.concat([
            Observable.just(Mutation.setLoading(true)),
            loadMoreImage,
            Observable.just(Mutation.setLoading(false))
        ])
    }
    
    fileprivate func notEmptySearchKeyword(_ keyword: String) -> Observable<Mutation> {
        return self.imageSearchUseCase.searchImage(query: keyword, size: Constants.itemCount)
            .catchError({ [weak self] error -> Observable<List<Documents>> in
                guard let self = self else { return .empty()}
                let alertActions: [BaseAlertAction] = [.cancel, .ok]
                return self.alertService.show(title: "",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert,
                                              actions: alertActions)
                    .do(onNext: {  [weak self] alertAction in
                        guard let self = self else { return }
                        switch alertAction {
                            case .ok:
                                self.internalMutationStream.accept(self.notEmptySearchKeyword(keyword))
                            case .cancel:
                                break
                        }
                    })
                    .flatMap { _ -> Observable<List<Documents>> in
                        return Observable.empty()
                    }
            })
            .map(Mutation.searchImage)
    }
    
    private func showKeyboard() -> Observable<Mutation> {
        return Observable.concat([
            Observable.just(.showKeyboard(Void())),
            Observable.just(.showKeyboard(nil))
        ])
    }
    
    private func selectedSearchImageItem(_ row: Int) -> Observable<Mutation> {
        
        if self.currentState.list.total <= 0 {
            return Observable.empty()
        }
        
        let cellModel = self.currentState.sections[0].items.compactMap { items ->
            SearchImageCellReactor? in
            if case let HomeSection.Item.image(value) = items {
                return value
            }
            return nil
        }
        
        let document = cellModel[row].initialState.documents
        
        
        let dto = SearchImageDTO(imageUrl: document.imageUrl,
                                 displaySiteName: document.displaySitename,
                                 dateTime: document.datetime,
                                 width: document.width,
                                 height: document.height)
        
        return Observable.just(Mutation.selectedItem(dto))
    }
}
