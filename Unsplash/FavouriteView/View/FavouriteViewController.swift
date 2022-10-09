//
//  FavouriteViewController.swift
//  Unsplash
//
//  Created by Ярослав Акулов on 05.10.2022.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    private var tableView: UITableView?
    
    var viewModel: FavouriteViewControllerViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel = viewModel else { return }
        viewModel.updatePhotos { tableView?.reloadData() }
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: self.view.frame,
                                style: .plain)
        tableView?.register(FavouriteTableViewCell.self,
                            forCellReuseIdentifier: FavouriteTableViewCell.reuseID)
        tableView?.dataSource = self
        tableView?.delegate = self
        guard let tableView = tableView else { return }
        self.view.addSubview(tableView)
    }
}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.reuseID,
                                                       for: indexPath) as? FavouriteTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.viewModelForCellAtIndexPath(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let detailVC = DetailViewController()
        detailVC.viewModel = viewModel.viewModelForDetailViewController(indexPath: indexPath)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
