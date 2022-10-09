//
//  FetchType.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import Foundation

enum FetchType {
    case randomPhotos
    case search(result: String)
    
    var body: String {
        switch self {
        case .randomPhotos:
            return "photos/random?count=30"
        case .search(let result):
            return "search/photos?query=\(result)"
        }
    }
}
