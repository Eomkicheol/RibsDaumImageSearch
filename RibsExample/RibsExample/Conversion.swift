//
//  Conversion.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import ObjectMapper

struct Conversion: Mappable {
    var errorType: String
    var message: String

    init() {
        errorType = ""
        message = ""
    }

    init?(map: Map) {
        errorType = ""
        message = ""
    }

    mutating func mapping(map: Map) {
        errorType <- map["errorType"]
        message <- map["message"]
    }
}
