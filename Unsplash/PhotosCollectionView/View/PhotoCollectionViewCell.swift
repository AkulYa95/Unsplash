//
//  PhotoCollectionViewCell.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 06.10.2022.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let reuseID = "PhotoCollectionCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .systemFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewModel: PhotoCollectionViewCellViewModelProtocol? {
        didSet {
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel else { return }
                self.configureViewWith(viewModel)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
        configureConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    private func configureViewWith(_ viewModel: PhotoCollectionViewCellViewModelProtocol) {
        self.photoImageView.fetchImageFrom(url: viewModel.imageURL)
        self.authorLabel.text = viewModel.authorName
        self.layoutIfNeeded()
    }
    
    private func configureCell() {
        self.addSubview(photoImageView)
        self.addSubview(authorLabel)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor,
                                             constant: 10),
            authorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            authorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
