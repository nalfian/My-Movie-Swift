//
//  FailureResponse.swift
//  MyMovie
//
//  Created by Unknown on 04/09/19.
//  Copyright © 2019 Nalfian. All rights reserved.
//

import Foundation

struct FailureResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension FailureResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
