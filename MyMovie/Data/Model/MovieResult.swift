//
//  MovieResult.swift
//  MyMovie
//
//  Created by Unknown on 04/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import Foundation

struct MovieResult: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
