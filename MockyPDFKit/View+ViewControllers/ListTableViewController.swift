//
//  ListTableViewController.swift
//  MockyPDFKit
//
//  Created by Yefga on 31/07/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    private let viewModel = ListViewModel()
    
    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        self.tableView.tableFooterView = UIView()
        
        self.tableView.addSubview(indicatorView)
        self.indicatorView.style = .gray
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.indicatorView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor, constant: 0),
            self.indicatorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 3),
        ])
    }
    
    fileprivate func updateUI() {
        viewModel.fetch(onLoading: {
            self.reloadData(isAnimating: true)
        }) {
            self.reloadData(isAnimating: false)
        }
    }
    
    
    fileprivate func reloadData(isAnimating: Bool) {
        DispatchQueue.main.async {
            isAnimating ? self.indicatorView.startAnimating() : self.indicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        let viewModel = DetailViewModel(item: item)
        let viewController = DetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }
    
}

