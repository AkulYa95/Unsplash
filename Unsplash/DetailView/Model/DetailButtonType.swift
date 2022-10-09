//
//  DetailButtonType.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 09.10.2022.
//

import Foundation

enum DetailButtonType {
    case save
    case delete
    
    var buttonTitle: String {
        switch self {
        case .save:
            return "Add to favourites"
        case .delete:
            return "Delete from favourites"
        }
    }
    var buttonColor: String {
        switch self {
        case .save:
            return "myBlue"
        case .delete:
            return "myRed"
        }
    }
}
