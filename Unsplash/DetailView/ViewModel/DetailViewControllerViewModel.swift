//
//  DetailViewControllerViewModel.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 08.10.2022.
//

import Foundation

protocol DetailViewControllerViewModelProtocol {
    var imageURL: String { get }
    var authorName: String? { get }
    var createDate: String? { get }
    var location: String? { get }
    var downloadsCount: String? { get }
    var buttonTitle: String { get }
    var buttonColor: String { get }
    func buttonAction(_ completion: () -> Void)
}

final class DetailViewControllerViewModel {
    
    private let photo: Photo
    private var buttonType: DetailButtonType {
        guard let id = photo.id else { return .save }
        if CoreDataManager.shared.isPhotoExist(with: id) {
            return .delete
        }
        return.save
    }
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    private func convertedDate(from stringDate: String?) -> String? {
        guard let stringDate = stringDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: stringDate) else { return nil }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let stringValue = dateFormatter.string(from: date)
        return stringValue
    }
}

extension DetailViewControllerViewModel: DetailViewControllerViewModelProtocol {
    var buttonColor: String {
        return buttonType.buttonColor
    }
    
    func buttonAction(_ completion: () -> Void) {
        switch buttonType {
        case .save:
            CoreDataManager.shared.save(photo)
        case .delete:
            CoreDataManager.shared.delete(photo: photo)
        }
        completion()
    }
    
    var buttonTitle: String {
        return buttonType.buttonTitle
    }
    
    var downloadsCount: String? {
        guard let count = photo.downloadsCount else { return nil }
        return "Downloads: \(count)"
    }
    
    var location: String? {
        guard let locationName = photo.location?.name else { return nil }
        return "Location: \(locationName)"
    }
    
    var createDate: String? {
        guard let date = convertedDate(from: photo.createdDate) else { return nil }
        return "Created at: \(date)"
    }
    
    var authorName: String? {
        guard let userName = photo.user?.name else { return nil }
        return "Author name: \(userName)"
    }
    
    var imageURL: String {
        return photo.urls?.small ?? ""
    }
}
