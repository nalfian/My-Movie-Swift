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
    case downloadImage(String)
}

extension MovieApi: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3") else { fatalError("baseURL could not be configured") }
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w500") else { fatalError("baseURL could not be configured") }
        switch self {
        case .downloadImage:
             return urlImage
        default:
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getNowPlaying:
            return "/movie/now_playing"
        case .getUpcoming:
            return "/movie/upcoming"
        case .search:
            return "/search/movie"
        case .downloadImage(let path):
            return path
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
        case .downloadImage:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let authParams = ["api_key": MovieClient.apiKey]
        switch self {
        case .getNowPlaying:
             return .requestParameters(parameters: authParams, encoding: URLEncoding.queryString)
        case .getUpcoming:
            return .requestParameters(parameters: authParams, encoding: URLEncoding.queryString)
        case .search(let query):
            return .requestParameters(parameters: ["query": query, "api_key": MovieClient.apiKey], encoding: URLEncoding.queryString)
        case .downloadImage:
            return .requestPlain
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
    func downloadImage(path: String, completion: @escaping (Data?, Error?) -> ())
}
