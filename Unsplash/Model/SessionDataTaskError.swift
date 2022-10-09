//
//  SessionDataTaskError.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import Foundation

enum SessionDataTaskError: Error {
    
    case failErr(Error)
    case responseStatusCodeErr(Int)
    case dataIsNil
    case jsonError(Error)
    case invalidURL
    
    var errorDescription: String {
        switch self {
        case .failErr(let error), .jsonError(let error):
            return error.localizedDescription
        case .responseStatusCodeErr(let statusCode):
            return "Status code is \(statusCode)"
        case .dataIsNil:
            return "No data in request"
        case .invalidURL:
            return "InvalidURL"
        }
    }
}
