//
//  MainTabBarController.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 05.10.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        DispatchQueue.main.async {
            let photoVC = PhotosCollectionViewController()
            let favouriteVC = FavouriteViewController()
            
            photoVC.viewModel = PhotoCollectionViewViewModel()
            favouriteVC.viewModel = FavouriteViewControllerViewModel()
            self.viewControllers = [
                self.createNavController(for: photoVC,
                                            title: "Photos",
                                            image: UIImage(systemName: "photo.on.rectangle.angled")),
                self.createNavController(for: favouriteVC,
                                            title: "Favourites",
                                            image: UIImage(systemName: "heart"))
            ]
        }
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage?,
                                     isLargeTitle: Bool = false) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = isLargeTitle
        rootViewController.navigationItem.title = title
        return navController
    }
}
