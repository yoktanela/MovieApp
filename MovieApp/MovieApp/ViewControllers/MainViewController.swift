//
//  ViewController.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    var searchController: UISearchController!
    var moviesTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var moviesViewModel: MoviesViewModel!
    private var dataSource : MovieTableViewDataSource<MovieTableViewCell,Movie>!
    private var page: Int = 1
    private var searchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create tableview
        self.moviesTableView = UITableView(frame: self.view.frame)
        self.view.addSubview(moviesTableView)
        let topConstraint = self.moviesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        self.view.addConstraints([topConstraint])
        moviesTableView.delegate = self
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        moviesTableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "PersonTableViewCell")
        moviesTableView.separatorStyle = .none
        
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

        //searchController.searchBar.delegate = self
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
        
        self.moviesViewModel.movies.asObservable().bind(to: self.moviesTableView.rx.items) { (tableView, row, element ) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: IndexPath(row : row, section : 0)) as! MovieTableViewCell
            cell.customizeCell(movie: element)
            return cell
        }.disposed(by: disposeBag)
        
        self.moviesTableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { movie in
                let movieDetailViewController = MovieDetailViewController()
                movieDetailViewController.movieId = movie.id
                self.navigationController?.pushViewController(movieDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            page += 1
            moviesViewModel.callFunctionToGetMovieData(page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerTitle = "Movies"
        
        let headerView: SectionHeaderView = SectionHeaderView.init(frame: CGRect.init(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.frame.width, height: 50))
        headerView.setTitle(title: headerTitle)
        return headerView
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMode = true
        moviesViewModel.callFuntionToGetSearchResults(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        moviesViewModel.clearSearchResults()
        searchMode = false
    }
}
