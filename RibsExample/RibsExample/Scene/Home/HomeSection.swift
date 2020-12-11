//
//  HomeSection.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//


import RxDataSources

struct HomeSection: Equatable {
    enum Identity: String {
        case image
        case empty
    }
    let identity: Identity
    var items: [Item]
}

extension HomeSection: AnimatableSectionModelType {
    init(original: HomeSection, items: [Item]) {
        self = HomeSection(identity: original.identity, items: items)
    }
}

extension HomeSection {
    enum Item: Hashable {
        case image(SearchImageCellReactor)
        case empty
    }
}

extension HomeSection.Item: IdentifiableType {
    var identity: String {
        return "\(self.hashValue)"
    }
}
