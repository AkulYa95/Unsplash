//
//  PhotoCollectionViewCellViewModel.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import Foundation

protocol PhotoCollectionViewCellViewModelProtocol {
    var authorName: String { get }
    var imageURL: String { get }
}

final class PhotoCollectionViewCellViewModel {
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
}

extension PhotoCollectionViewCellViewModel: PhotoCollectionViewCellViewModelProtocol {
    var imageURL: String {
        return photo.urls?.small ?? ""
    }
    
    var authorName: String {
        return photo.user?.name ?? ""
    }
}
