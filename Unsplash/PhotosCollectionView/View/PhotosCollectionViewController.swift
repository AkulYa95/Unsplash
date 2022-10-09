//
//  PhotosCollectionViewController.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 05.10.2022.
//

import UIKit

final class PhotosCollectionViewController: UIViewController {
    
    private let searchController = UISearchController()
    private var collectionView: UICollectionView?
    var viewModel: PhotoCollectionViewViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
        guard let viewModel = viewModel else { return }
        viewModel.getPhotos { error in
            guard let error = error else {
                self.collectionView?.reloadData()
                return
            }
            self.showAlertWithMessage(error.errorDescription)
        }
    }
    
    private func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: self.view.frame,
                                          collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseID)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        guard let collectionView = collectionView else { return }
        self.view.addSubview(collectionView)
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
}
// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchPhotosWith(tag: searchText,
                                    completion: { error in
            guard error == nil else { return }
            self.collectionView?.reloadData()
        })
    }
    
}
// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseID,
                                                            for: indexPath) as? PhotoCollectionViewCell,
              let viewModel = viewModel else {
                  return UICollectionViewCell()
              }
        cell.viewModel = viewModel.viewModelForCellAtIndexPath(indexPath: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let detailVC = DetailViewController()
        detailVC.viewModel = viewModel.viewModelForDetailViewController(indexPath: indexPath)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
