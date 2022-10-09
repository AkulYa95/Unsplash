//
//  ApiManager.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import Foundation

final class ApiManager {
    private let mainURlString = "https://api.unsplash.com/"
    private let accessKey = "EwUxFKIlfzSuadr7kPJIzz2TKamoCUrp4y-oE8jOcyo"
    private let header = "Authorization"
    
    private let secretKey = "lbGQ4Y-1OPgWgyfT6UAWsPwzu1WBmBpMpgi1DcBvD0I"
    
    private func photosFrom(searchData: SearchData) -> [Photo] {
        var photos: [Photo] = []
        searchData.results.forEach { result in
            let object = Photo(id: result.id,
                               createdDate: result.createdDate,
                               downloadsCount: nil,
                               location: nil,
                               user: result.user,
                               urls: result.urls)
            photos.append(object)
        }
        return photos
    }
    
    func fetchData(fetchType: FetchType, completion: @escaping (([Photo], SessionDataTaskError?) -> Void)) {
        guard let url = URL(string: "\(mainURlString)\(fetchType.body)") else {
            completion([], .invalidURL)
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: header)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion([], .failErr(error))
                    return
                }
                if let response = response as? HTTPURLResponse {
                    guard 200 ..< 300 ~= response.statusCode else {
                        completion([], .responseStatusCodeErr(response.statusCode))
                        return
                    }
                }
                guard let data = data else {
                    completion([], .dataIsNil)
                    return
                }
                do {
                    var photoCards: [Photo] = []
                    switch fetchType {
                    case .randomPhotos:
                        let result = try JSONDecoder().decode([Photo].self, from: data)
                        photoCards = result
                    case .search:
                        let result = try JSONDecoder().decode(SearchData.self, from: data)
                        photoCards = self.photosFrom(searchData: result)
                    }
                    completion(photoCards, nil)
                } catch {
                    completion([], .jsonError(error))
                }
            }
        }.resume()
    }
}
