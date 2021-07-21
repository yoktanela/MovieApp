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
        
        self.moviesViewModel.bindMoviesSearchResultsViewModelToController = {
            self.updateDataSource()
        }
        
        self.moviesViewModel.bindPeopleSearchResultsViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async {
            self.moviesTableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerTitle = "Movies"
        if (moviesViewModel.moviesSearchResult != nil && section == 0) {
            if (section != 0) {
                headerTitle = "People"
            }
        } else if (moviesViewModel.peopleSearchResult != nil) {
            headerTitle = "People"
        }
        let headerView: SectionHeaderView = SectionHeaderView.init(frame: CGRect.init(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.frame.width, height: 50))
        headerView.setTitle(title: headerTitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (moviesViewModel.movies.count > indexPath.row) {
            let movie = moviesViewModel.movies[indexPath.row]
            let movieDetailViewController = MovieDetailViewController()
            movieDetailViewController.movieId = movie.id
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (moviesViewModel.moviesSearchResult != nil) {
            if (section == 0) {
                return moviesViewModel.moviesSearchResult?.count ?? 0
            } else if moviesViewModel.peopleSearchResult != nil {
                return moviesViewModel.peopleSearchResult?.count ?? 0
            }
        } else if (moviesViewModel.peopleSearchResult != nil) {
            return moviesViewModel.peopleSearchResult?.count ?? 0
        }
        return moviesViewModel.movies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionNumber = 0
        if (moviesViewModel.moviesSearchResult != nil) {
            sectionNumber += 1
        }
        if (moviesViewModel.peopleSearchResult != nil) {
            sectionNumber += 1
        }
        return sectionNumber == 0 ? 1 : sectionNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (moviesViewModel.moviesSearchResult != nil ) {
            if (indexPath.section == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
                cell.selectionStyle = .none
                let movie = self.moviesViewModel.moviesSearchResult?[indexPath.row] ?? self.moviesViewModel.movies[indexPath.row]
                cell.movie = movie
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
                cell.selectionStyle = .none
                let person = self.moviesViewModel.peopleSearchResult?[indexPath.row]
                cell.nameLabel.text = person?.name
                cell.setProfileImage(path: person?.profilePath)
                return cell
            }
        } else if (moviesViewModel.peopleSearchResult != nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
            cell.selectionStyle = .none
            let person = self.moviesViewModel.peopleSearchResult?[indexPath.row]
            cell.nameLabel.text = person?.name
            cell.setProfileImage(path: person?.profilePath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.selectionStyle = .none
        let movie = self.moviesViewModel.moviesSearchResult?[indexPath.row] ?? self.moviesViewModel.movies[indexPath.row] 
        cell.movie = movie
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMode = true
        moviesViewModel.callFuntionToGetSearchResults(searchText: searchText)
    }
}

