//
//  Extension + UIImageView.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 08.10.2022.
//

import UIKit

extension UIImageView {
    func fetchImageFrom(url: String) {
        contentMode = .scaleAspectFill
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let mimeType = response.mimeType, mimeType.hasPrefix("image"),
                  let data = data,
                  let image = UIImage(data: data) else {
                      return
                  }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
            }
        }.resume()
    }
}
