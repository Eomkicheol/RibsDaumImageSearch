//
//  SearchImageCellReactor.swift
//  RibsExample
//
//  Created by fitpet on 2020/12/02.
//

import ReactorKit
import RxCocoa
import RxSwift

class SearchImageCellReactor: Reactor, IdentityHashable {

    enum Action {}
    enum Mutation {}
    struct State {
        var documents: Documents
    }

    var event: Documents {
        return self.currentState.documents
    }

    let initialState: State
    init(event: Documents) {
        defer { _ = self.state }
        self.initialState = State(documents: event)
    }
}

