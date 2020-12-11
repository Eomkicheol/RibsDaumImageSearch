//
//  SearchImageAPI.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import Moya

enum SearchImageAPI {
    case search(query: String, size: Int)
    case loadMoreImage(dto: PaginationDTO)
}

extension SearchImageAPI: BaseAPI {
    var path: String {
        return "/image"
    }

    var method: Method {
        switch self {
            case .search, .loadMoreImage:
                return .get
        }
    }

    var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .search, .loadMoreImage:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }


    var parameters: [String: Any]? {
        switch self {
            case .search(let query, let size):
                return ["query": query, "size": size]
            case .loadMoreImage(let dto):
                return dto.asParameters(dto: dto)
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
            case .search, .loadMoreImage:
                return URLEncoding.queryString
        }
    }
}

