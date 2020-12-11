//
//  SearchEntities.swift
//  RibsExample
//
//  Created by Hanzo on 2020/12/01.
//

import ObjectMapper

struct SearchEntities: Mappable {
    var meta: Meta
    var documents: [Documents]

    init() {
        meta = Meta()
        documents = []
    }

    init?(map: Map) {
        meta = Meta()
        documents = []
    }

    mutating func mapping(map: Map) {
        meta <- map["meta"]
        documents <- map["documents"]
    }
}

struct Meta: Mappable, Equatable {

    var isEnd: Bool
    var pageableCount: Int
    var totalCount: Int

    init() {
        isEnd = false
        pageableCount = 0
        totalCount = 0
    }

    init?(map: Map) {
        isEnd = false
        pageableCount = 0
        totalCount = 0
    }

    mutating func mapping(map: Map) {
        isEnd <- map["is_end"]
        pageableCount <- map["pageable_count"]
        totalCount <- map["total_count"]
    }
}


struct Documents: Mappable, Hashable {

    var collection: String
    var datetime: String
    var displaySitename: String
    var docUrl: String
    var height: CGFloat
    var imageUrl: String
    var thumbnailUrl: String
    var width: CGFloat

    init() {
        collection = ""
        datetime = ""
        displaySitename = ""
        docUrl = ""
        height = 0.0
        imageUrl = ""
        thumbnailUrl = ""
        width = 0.0
    }

    init?(map: Map) {
        collection = ""
        datetime = ""
        displaySitename = ""
        docUrl = ""
        height = 0.0
        imageUrl = ""
        thumbnailUrl = ""
        width = 0.0
    }

    mutating func mapping(map: Map) {
        collection <- map["collection"]
        datetime <- (map["datetime"], toDateTransform())
        displaySitename <- map["display_sitename"]
        docUrl <- map["doc_url"]
        height <- map["height"]
        imageUrl <- map["image_url"]
        thumbnailUrl <- map["thumbnail_url"]
        width <- map["width"]
    }
}


func toDateTransform() -> TransformOf<String, String> {
    return TransformOf(fromJSON: { (value: String?) -> String? in
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let target = value else { return nil }

        guard let date = dateFormatter.date(from: target) else { return nil }

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.locale = Locale(identifier: "ko_KR")
        convertDateFormatter.dateFormat = "yyyy/MM/dd (EE) a h:mm"
        convertDateFormatter.timeZone = .autoupdatingCurrent
        return convertDateFormatter.string(from: date)

    }, toJSON: { _ in
        return nil
    })
}

