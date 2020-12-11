//
//  HomeActionableItem.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/07.
//

import Foundation
import RxSwift

protocol HomeActionableItem: class {
  func routeToDetail() -> Observable<(DetailActionableItem, ())>
}
