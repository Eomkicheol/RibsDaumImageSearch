//
//  RootInteractor.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs
import RxSwift
import RxRelay

protocol RootRouting: ViewableRouting {
    func attachHomeRIB()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: class {}



final class RootInteractor: PresentableInteractor<RootPresentable>,
                            RootInteractable, RootPresentableListener,
                            UrlHandler {
    

    //RootActionableItem {
    
    
    weak var router: RootRouting?
    weak var listener: RootListener?
    
    
    //    let workflower: Workflow = Workflow()
    //
    //    private let mainActionableItemSubject = ReplaySubject<MainActionableItem>.create(bufferSize: 1)
    
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        //self.workflowMap(workflower: self.workflower)
        
        self.router?.attachHomeRIB()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func handle(_ url: URL) {
        #if DEBUG
        print(url)
        #endif
        
        //          return self.workflower.handle(for: url)
    }
}


