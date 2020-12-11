//
//  AppComponent.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RIBs
import Swinject

private let globalContainer = Container()

extension Component {
    var container: Container {
         return globalContainer
    }
}

class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
        self.makeInjection(self.container)
    }

    private func makeInjection(_ container: Container) {
        container.register(Networking.self) { _ in
            return Networking(logger: [AccessToKenPlugin()])
        }.inObjectScope(.container)

        container.register(ImageSearchRepositoriesProtocol.self) { r in
            return ImageSearchRepositories(networking: r.resolve(Networking.self)!)
        }.inObjectScope(.container)

        container.register(HomeSearchImageUseCaseProtocol.self) { r in
            return HomeSearchUseCase(repository:
                                        r.resolve(ImageSearchRepositoriesProtocol.self)!)
        }.inObjectScope(.container)
        
    }
}
