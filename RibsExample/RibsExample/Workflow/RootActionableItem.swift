//
//  RootActionableItem.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/07.
//


import RxSwift

protocol RootActionableItem: class {
  func waitForHome() -> Observable<(HomeActionableItem, ())>
}

