//
//  SearchImageDTO.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import Foundation
import UIKit

struct SearchImageDTO: Hashable {
    var imageUrl: String
    var displaySiteName: String
    var dateTime: String
    var width: CGFloat
    var height: CGFloat
    var ratio: CGFloat {
        return height / width
    }

    init(imageUrl: String,
         displaySiteName: String,
         dateTime: String,
         width: CGFloat,
         height: CGFloat) {
        self.imageUrl = imageUrl
        self.displaySiteName = displaySiteName
        self.dateTime = dateTime
        self.width = width
        self.height = height
    }
}


extension SearchImageDTO {
    init() {
        self.imageUrl = ""
        self.displaySiteName = ""
        self.dateTime = ""
        self.width = 0.0
        self.height = 0.0
        }
    }
