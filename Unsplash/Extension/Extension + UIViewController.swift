//
//  Extension + UIViewController.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import UIKit

extension UIViewController {
    func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
