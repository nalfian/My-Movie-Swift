//
//  MovieClient.swift
//  MyMovie
//
//  Created by Unknown on 04/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import Foundation

class MovieClient{
    
    static let apiKey = "221fbf2bcc939e0de03af53af4e1744a"
    
    enum EndPoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(MovieClient.apiKey)"
        
        case getNowPlaying
        case getUpcoming
        case search(String)
        case posterImage(String)
        
        var stringValue: String{
            switch self {
            case .getNowPlaying:
                return EndPoints.base + "/movie/now_playing" + EndPoints.apiKeyParam
            case .getUpcoming:
                return EndPoints.base + "/movie/upcoming" + EndPoints.apiKeyParam
            case .search(let keyword):
                return EndPoints.base + "/search/movie" + EndPoints.apiKeyParam + "&query=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            case .posterImage(let path):
                return "https://image.tmdb.org/t/p/w500/" + path
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
}
