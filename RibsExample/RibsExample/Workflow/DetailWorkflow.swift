//
//  DetailWorkflow.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/07.
//

import RIBs
import RxSwift

class DetailWorkflow: Workflow<RootActionableItem> {
  
  init(orderNum: String) {
    super.init()
    
//    self
//      .onStep { (rootActionableItem: RootActionableItem) -> Observable<(MainActionableItem, ())> in
//        return rootActionableItem.waitForMain()
//      }
//      .onStep { (mainActionableItem: MainActionableItem, _) -> Observable<(MainActionableItem, ())> in
//        return mainActionableItem.waitForSignIn()
//      }
//      .onStep { (mainActionableItem: MainActionableItem, _) -> Observable<(OrdersActionableItem, ())> in
//        return mainActionableItem.routeToOrders()
//      }
//      .onStep { (ordersActionableItem: OrdersActionableItem, _) -> Observable<(OrdersActionableItem, ())> in
//        return ordersActionableItem.routeToOrder(orderNum: orderNum)
//      }
//      .commit()
  }
}
