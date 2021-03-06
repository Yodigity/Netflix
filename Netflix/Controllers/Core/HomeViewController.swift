//
//  HomeViewController.swift
//  Netflix
//
//  Created by Aaron Gokani on 24/05/2022.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending movies", "Trending Tv", "Popular", "Top Rated", "Upcoming Movies"]
    
    private let homeFeedTable: UITableView = {
        
        // .grouped === same style as settings page of iPhone
        let table = UITableView(frame: .zero, style: .grouped)
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "CollectionViewTableViewCell")
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        getTrendingMovies()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflix_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
       
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    
    
    
    private func getTrendingMovies() {
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getTrendingTvs() {
        APICaller.shared.getTrendingTvs { results in
            switch results {
            case .success(let tvs):
                print(tvs)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getPopularMovies() {
        APICaller.shared.getPopularMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getUpcomingMovies() {
        APICaller.shared.getUpcomingMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getTopRatedMovies() {
        APICaller.shared.getTopRatedMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTvs.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    //Implement titlebar sticky when doing refresh scroll, but hides when scrolling down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    
    
    
}
