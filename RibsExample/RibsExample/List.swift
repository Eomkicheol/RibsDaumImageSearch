//
//  List.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import Foundation

struct List<Element> {
    var items: [Element]
    var canLoadNext: Bool
    var nextPage: Int?
    var total: Int
    
    init(items: [Element], canLoadNext: Bool, nextPage: Int? = nil, total: Int) {
        self.items = items
        self.canLoadNext = canLoadNext
        self.nextPage = nextPage
        self.total = total
    }
}

extension List {
    init() {
        self.items = []
        self.canLoadNext = false
        self.nextPage = nil
        self.total = 0
    }
}
