//
//  AccessToKenPlugin.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import Moya

final class AccessToKenPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        var headerRequest = request
        headerRequest.addValue(Enviroment.kakaokey, forHTTPHeaderField: "Authorization")
        return headerRequest
    }
}
