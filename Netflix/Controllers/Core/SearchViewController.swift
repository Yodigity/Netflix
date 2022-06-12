//
//  SearchViewController.swift
//  Netflix
//
//  Created by Aaron Gokani on 24/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var titles: [Title] = [Title]()
    
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return table
    }()
    
    private let searchContoller: UISearchController = {
       let controller = UISearchController(searchResultsController: SearchResultsViewController())
        
        controller.searchBar.placeholder = "Search for a movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchContoller
        
        fetchDiscoverMovies()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { result in
            switch result {
            case .success(let movies):
                self.titles = movies
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = discoverTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown", posterUrl: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
