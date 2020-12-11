//
//  PaginationDTO.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

struct PaginationDTO {
    var query: String
    var sort: String
    var page: Int
    var size: Int

    init(query: String, sort: String = "accuracy",
         page: Int, size: Int) {
        self.query = query
        self.sort = sort
        self.page = page
        self.size = size
    }

    func asParameters(dto: PaginationDTO) -> [String: Any] {

        var parmeter: [String: Any] = [:]

        parmeter.merge(dict: ["query": query,
                              "sort": dto.sort,
                              "page": dto.page,
                              "size": dto.size])
        return parmeter
    }
}
