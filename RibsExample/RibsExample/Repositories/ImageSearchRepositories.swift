//
//  ImageSearchRepositories.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import RxSwift
import RxCocoa
import RxOptional

protocol ImageSearchRepositoriesProtocol: class {
    func searchImage(query: String, size: Int) -> Observable<List<Documents>>
    func loadMoreSearchImage(dto: PaginationDTO) -> Observable<List<Documents>>
}

final class ImageSearchRepositories: ImageSearchRepositoriesProtocol {

    private let networking: NetworkingProtocol

    init(networking: NetworkingProtocol) {
        self.networking = networking
    }

    func searchImage(query: String, size: Int) -> Observable<List<Documents>> {
        return self.networking.request(SearchImageAPI.search(query: query, size: size))
            .asObservable()
            .mapString()
            .map { SearchEntities(JSONString: $0) ?? SearchEntities() }
            .compactMap {
                List<Documents>(items: $0.documents,
                     canLoadNext: $0.meta.isEnd, nextPage: $0.meta.pageableCount,
                     total: $0.meta.totalCount)
            }
            .flatMap { data -> Observable<List<Documents>> in
                return Observable.just(data)
            }
    }

    func loadMoreSearchImage(dto: PaginationDTO) -> Observable<List<Documents>> {
        return self.networking.request(SearchImageAPI.loadMoreImage(dto: dto))
            .asObservable()
            .mapString()
            .map { SearchEntities(JSONString: $0) ?? SearchEntities() }
            .map {
                List(items: $0.documents,
                     canLoadNext: $0.meta.isEnd, nextPage: $0.meta.pageableCount,
                     total: $0.meta.totalCount)
            }
            .flatMap { data -> Observable<List<Documents>> in
                return Observable.just(data)
            }
    }
}
