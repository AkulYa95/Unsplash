//
//  FavoriteTableViewCell.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 08.10.2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    static let reuseID = "FavoriteTableViewCell"
    
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
        label.font = .systemFont(ofSize: 15)
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
        
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
        configureConstraints()
    }
    
    private func configureViewWith(_ viewModel: PhotoCollectionViewCellViewModelProtocol) {
        self.photoImageView.fetchImageFrom(url: viewModel.imageURL)
        self.authorLabel.text = viewModel.authorName
        self.setNeedsLayout()
    }
    
    private func configureCell() {
        self.selectionStyle = .none
        self.addSubview(photoImageView)
        self.addSubview(authorLabel)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(equalToConstant: 70),
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                    constant: 10),
            photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor,
                                                 constant: 10),
            authorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

}
