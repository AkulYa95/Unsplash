//
//  DetailViewController.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 07.10.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorNameLabel = UILabel()
    private let createDateLabel = UILabel()
    private let locationLabel = UILabel()
    private let downloadsCountLabel = UILabel()
    private var labelsStackView = UIStackView()
    
    private let dataBaseButton = UIButton(type: .system)
    
    var viewModel: DetailViewControllerViewModelProtocol? {
        didSet {
            DispatchQueue.main.async {
                guard let viewModel = self.viewModel else { return }
                self.configureViewWith(viewModel)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureLabels([authorNameLabel, createDateLabel, downloadsCountLabel, locationLabel])
        self.view.addSubview(photoImageView)
        self.view.addSubview(dataBaseButton)
        configureConstraints()
    }
        
    private func configureLabels(_ labels: [UILabel]) {
        labels.forEach { label in
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 17)
        }
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.labelsStackView = stackView
        self.view.addSubview(self.labelsStackView)
    }
    
    private func configureButtonWith(_ viewModel: DetailViewControllerViewModelProtocol) {
        dataBaseButton.translatesAutoresizingMaskIntoConstraints = false
        dataBaseButton.backgroundColor = .white
        dataBaseButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        updateButtonWith(viewModel)
    }
    
    private func updateButtonWith(_ viewModel: DetailViewControllerViewModelProtocol) {
        dataBaseButton.setTitle(viewModel.buttonTitle, for: .normal)
        dataBaseButton.setTitleColor(UIColor(named: viewModel.buttonColor),
                                     for: .normal)
    }
    
    private func configureViewWith(_ viewModel: DetailViewControllerViewModelProtocol) {
        photoImageView.fetchImageFrom(url: viewModel.imageURL)
        authorNameLabel.text = viewModel.authorName
        createDateLabel.text = viewModel.createDate
        locationLabel.text = viewModel.location
        downloadsCountLabel.text = viewModel.downloadsCount
        configureButtonWith(viewModel)
    }
    
    @objc
    private func buttonAction() {
        guard let viewModel = viewModel else { return }
        viewModel.buttonAction {
            updateButtonWith(viewModel)
        }
    }
    
    private func configureConstraints() {
        configureImageViewConstraints()
        configureLabelsStackViewConstraints()
        configureButtonConstraints()
    }
    
    private func configureImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.photoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.photoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.photoImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10)
        ])
    }
    
    private func configureLabelsStackViewConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: self.photoImageView.bottomAnchor, constant: 10),
            labelsStackView.leadingAnchor.constraint(equalTo: self.photoImageView.leadingAnchor),
            labelsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func configureButtonConstraints() {
        NSLayoutConstraint.activate([
            dataBaseButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            dataBaseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dataBaseButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: 10),
            dataBaseButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
