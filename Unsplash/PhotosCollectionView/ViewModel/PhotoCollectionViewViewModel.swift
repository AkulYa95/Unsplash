//
//  PhotoCollectionViewViewModel.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import Foundation

protocol PhotoCollectionViewViewModelProtocol {
    var photosCount: Int { get }
    func getPhotos(completion: @escaping ((SessionDataTaskError?) -> Void))
    func searchPhotosWith(tag: String?, completion: @escaping ((SessionDataTaskError?) -> Void))
    func viewModelForCellAtIndexPath(indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol?
    func viewModelForDetailViewController(indexPath: IndexPath) -> DetailViewControllerViewModelProtocol?
}

final class PhotoCollectionViewViewModel {
    private let apiManager = ApiManager()
    var photos: [Photo] = []
}

extension PhotoCollectionViewViewModel: PhotoCollectionViewViewModelProtocol {
    var photosCount: Int {
        return photos.count
    }
    
    func viewModelForDetailViewController(indexPath: IndexPath) -> DetailViewControllerViewModelProtocol? {
        return DetailViewControllerViewModel(photo: photos[indexPath.row])
    }
    
    func searchPhotosWith(tag: String?, completion: @escaping ((SessionDataTaskError?) -> Void)) {
        guard let tag = tag else { return }
        var fetchType: FetchType = .randomPhotos
        if !tag.isEmpty {
            fetchType = .search(result: tag)
        }
        apiManager.fetchData(fetchType: fetchType) { photos, error in
            guard error == nil else { return }
            self.photos = photos
            completion(nil)
        }
    }

    func viewModelForCellAtIndexPath(indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol? {
        guard photos.indices.contains(indexPath.row) else { return nil }
        return PhotoCollectionViewCellViewModel(photo: photos[indexPath.row])
    }
    
    func getPhotos(completion: @escaping ((SessionDataTaskError?) -> Void)) {
        apiManager.fetchData(fetchType: .randomPhotos) { photos, error in
            guard let error = error else {
                self.photos = photos
                completion(nil)
                return
            }
            completion(error)
        }
    }
}
