//
//  MovieApi.swift
//  MyMovie
//
//  Created by Unknown on 03/02/20.
//  Copyright © 2020 Nalfian. All rights reserved.
//

import Foundation
import Moya

enum MovieApi {
    case getNowPlaying
    case getUpcoming
    case search(String)
}

extension MovieApi: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3") else { fatalError("baseURL could not be configured") }
        return url 
    }
    
    var path: String {
        switch self {
        case .getNowPlaying:
            return "/movie/now_playing"
        case .getUpcoming:
            return "/movie/upcoming"
        case .search:
            return "/search/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNowPlaying:
            return .get
        case .getUpcoming:
            return .get
        case .search:
            return .get
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getNowPlaying:
             return .requestParameters(parameters: ["api_key": MovieClient.apiKey], encoding: URLEncoding.queryString)
        case .getUpcoming:
            return .requestParameters(parameters: ["api_key": MovieClient.apiKey], encoding: URLEncoding.queryString)
        case .search(let query):
            return .requestParameters(parameters: ["query": query, "api_key": MovieClient.apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
       return ["Content-type": "application/json; charset=UTF-8"]
    }
}

protocol Networkable {
    var provider: MoyaProvider<MovieApi> { get }
    func getNowPlaying(completion: @escaping ([Movie], Error?) -> ())
    func getUpcoming(completion: @escaping ([Movie], Error?) -> ())
    func search(query: String, completion: @escaping ([Movie], Error?) -> ())
}
