//
//  HomeSearchImageUseCase.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import RxSwift
import RxCocoa


protocol HomeSearchImageUseCaseProtocol: class {
    func searchImage(query: String, size: Int) -> Observable<List<Documents>>
    func loadMoreSearchImage(dto: PaginationDTO) -> Observable<List<Documents>>
}


final class HomeSearchUseCase: HomeSearchImageUseCaseProtocol {

    private let repository: ImageSearchRepositoriesProtocol

    init(repository: ImageSearchRepositoriesProtocol) {
        self.repository = repository
    }

    func searchImage(query: String, size: Int) -> Observable<List<Documents>> {
        return self.repository.searchImage(query: query, size: size)
    }

    func loadMoreSearchImage(dto: PaginationDTO) -> Observable<List<Documents>> {
        return self.repository.loadMoreSearchImage(dto: dto)
    }
}
