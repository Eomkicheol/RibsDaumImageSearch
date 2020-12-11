//
//  BaseAPI.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import Moya

protocol BaseAPI: TargetType {}

enum BaseApiError {
    case errorMessage(String)
}

extension BaseAPI {
    var baseURL: URL {
        return Enviroment.baseURL
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        guard let data = "Data".data(using: String.Encoding.utf8) else { return Data() }
        return data
    }
}

extension BaseApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .errorMessage(let message):
                return NSLocalizedString(message, comment: "Server Error")
        }
    }
}

