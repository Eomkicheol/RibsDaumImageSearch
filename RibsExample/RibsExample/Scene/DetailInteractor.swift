//
//  DetailInteractor.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/03.
//

import RIBs
import RxSwift
import ReactorKit

protocol DetailRouting: ViewableRouting {}

protocol DetailPresentable: Presentable {
    var listener: DetailPresentableListener? { get set }
}

protocol DetailListener: class {}

struct DetailState {
    var configureImage: SearchImageDTO = .init()
}

final class DetailInteractor: PresentableInteractor<DetailPresentable>, DetailInteractable, DetailPresentableListener, Reactor {
    
    typealias Action = DetailViewAction
    typealias State = DetailState
    
    weak var router: DetailRouting?
    weak var listener: DetailListener?
    
    var initialState: State
    
    override init(presenter: DetailPresentable) {
        
        defer {
            _ = self.state
        }
        self.initialState = State()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
}



extension DetailInteractor {
    
    func mutate(action: DetailViewAction) -> Observable<DetailViewAction> {
        switch action {
            case .configureImage(let dto):
                return self.configureImageMutation(dto)
            
        }
    }
    
    func reduce(state: DetailState, mutation: DetailViewAction) -> DetailState {
        var newState = state
        switch mutation {
            case let .configureImage(items):
                newState.configureImage = items
        }
        
        return newState
    }
    
    private func configureImageMutation(_ dto: SearchImageDTO) -> Observable<Mutation> {
        return Observable.just(Mutation.configureImage(dto: dto))
    }

}
