//
//  ViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import UIKit

class MainViewController: UIViewController {

    var searchController: UISearchController!
    var moviesTableView: UITableView!
    private var moviesViewModel: MoviesViewModel!
    private var dataSource : MovieTableViewDataSource<MovieTableViewCell,Movie>!
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create tableview
        self.moviesTableView = UITableView(frame: self.view.frame)
        self.view.addSubview(moviesTableView)
        let topConstraint = self.moviesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        self.view.addConstraints([topConstraint])
        moviesTableView.delegate = self
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        
        createSearchBar()
        callToViewModelForUIUpdate()
    }

    func createSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            let searchBar = self.searchController.searchBar
            searchBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9843137255, alpha: 1)
            searchBar.backgroundImage = UIImage()
            moviesTableView.tableHeaderView = searchBar
        }

        searchController.searchBar.delegate = self
        searchController.searchBar.setImage(UIImage(named: "search_icon"), for:  UISearchBar.Icon.search, state: .normal)
        searchController.searchBar.tintColor = UIColor(netHex: 0x006ED5)
        if #available(iOS 11.0, *) {
            let topConstraint = self.moviesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
            self.view.addConstraints([topConstraint])
        } else {
            // Fallback on earlier versions
        }
    }
    
    func callToViewModelForUIUpdate() {
        self.moviesViewModel = MoviesViewModel()
        self.moviesViewModel.bindMoviesViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        self.dataSource = MovieTableViewDataSource(cellIdentifier: "MovieTableViewCell", items: self.moviesViewModel.movies, configureCell: { (cell, movie) in
            cell.movie = movie
        })
        
        DispatchQueue.main.async {
            self.moviesTableView.dataSource = self.dataSource
            self.moviesTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            page += 1
            moviesViewModel.callFunctionToGetMovieData(page: page)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
}

