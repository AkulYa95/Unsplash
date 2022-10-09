//
//  Photo.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import Foundation

struct Photo: Decodable {
    let id: String?
    let createdDate: String?
    let downloadsCount: Int?
    let location: Location?
    let user: User?
    let urls: Urls?
    
    private enum CodingKeys: String, CodingKey {
        case id, location, user, urls
        case createdDate = "created_at"
        case downloadsCount = "downloads"
    }
}

struct Location: Decodable {
    let name: String?
}

struct User: Decodable {
    let name: String?
}

struct Urls: Decodable {
    let small: String?
}

struct SearchData: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [Result]
    
    private enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

struct Result: Decodable {
    let id: String?
    let createdDate: String?
    let urls: Urls?
    let user: User?

    private enum CodingKeys: String, CodingKey {
        case id, urls, user
        case createdDate = "created_at"
    }
}
