//
//  FavouriteViewControllerViewModel.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 08.10.2022.
//

import Foundation

protocol FavouriteViewControllerViewModelProtocol {
    var photosCount: Int { get }
    func updatePhotos(_ completion: () -> Void)
    func viewModelForCellAtIndexPath(indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol?
    func viewModelForDetailViewController(indexPath: IndexPath) -> DetailViewControllerViewModelProtocol?
}

final class FavouriteViewControllerViewModel {
    var photos: [Photo]
    
    init() {
        self.photos = CoreDataManager.shared.getPhotos()
    }
}

extension FavouriteViewControllerViewModel: FavouriteViewControllerViewModelProtocol {
    func updatePhotos(_ completion: () -> Void) {
        self.photos = CoreDataManager.shared.getPhotos()
        completion()
    }
    
    func viewModelForCellAtIndexPath(indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol? {
        return PhotoCollectionViewCellViewModel(photo: photos[indexPath.row])
    }
    
    func viewModelForDetailViewController(indexPath: IndexPath) -> DetailViewControllerViewModelProtocol? {
        return DetailViewControllerViewModel(photo: photos[indexPath.row])
    }
    
    var photosCount: Int {
        return photos.count
    }
}
