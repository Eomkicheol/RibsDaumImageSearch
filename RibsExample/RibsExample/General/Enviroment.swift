//
//  Enviroment.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import Foundation

public final class Enviroment {
    public static let baseHost = "https://dapi.kakao.com"

    public static let baseURL: URL = {
        var componet = NSURLComponents(string: baseHost)
        componet?.path = "/v2/search"
        let url = componet?.url
        return url!
    }()

    public static let kakaokey: String = {
        return "KakaoAK cd28eff5453b4711aaf1b4bfe08245ac"
    }()
}
