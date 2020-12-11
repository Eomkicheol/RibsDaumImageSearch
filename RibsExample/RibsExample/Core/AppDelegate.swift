//
//  AppDelegate.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import UIKit
import RIBs

#if DEBUG
import netfox
#endif

protocol UrlHandler: class {
    func handle(_ url: URL)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var launchRouter: LaunchRouting?
    private var urlHandler: UrlHandler?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        #if DEBUG
        NFX.sharedInstance().start()
        #endif

        self.makeRootViewController()

        return true
    }

    private func makeRootViewController() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let result = RootBuilder(dependency: AppComponent()).build()
        let launchRouter = result.launchRouter
        self.launchRouter = launchRouter
        self.urlHandler = result.urlHandler

        launchRouter.launch(from: window)
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return self.urlHandler?.handle(url) ?? false
//      }
}
