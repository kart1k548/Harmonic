import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func didReceiveRecentTracks()
    func didReceiveNewReleases()
    func didTapOnAlbum(album: Album)
}

class HomeViewController: UIViewController {
    var presenter: HomePresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgColor
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .bgColor
        
        presenter?.viewDidLoad()
        setupNavigationView()
        setupTableView()
    }
    
    private func setupNavigationView() {
        let viewModel = HomeNavigationViewModel(name: presenter?.userProfile?.name ?? "",
                                                accountType: presenter?.userProfile?.product ?? "",
                                                photoUrl: presenter?.userProfile?.images.getImageUrl(for: .low) ?? "")
        
        let homeNavigationView = HomeNavigationView()
        homeNavigationView.configure(viewModel: viewModel)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeNavigationView)
                
        setRightBarButtonItem()
        setNavBarAppearance()
    }
    
    private func setRightBarButtonItem() {
        let searchButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        searchButton.makeButton(with: UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig), width: 24, height: 24, tintColor: .silverGrey)
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
    
    private func setNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .bgColor
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func setupTableView() {
        tableView.register(RecentlyPlayedCellView.self, forCellReuseIdentifier: RecentlyPlayedCellView.identifier)
        tableView.register(NewReleasesSectionView.self, forCellReuseIdentifier: NewReleasesSectionView.identifier)
        tableView.register(HomeSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeSectionHeaderView.identifier)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    @objc func didTapSearch() {
        let searchViewController = SearchViewController()
        let presenter = SearchPresenter(view: searchViewController, model: SearchModel())
        searchViewController.presenter = presenter
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            guard let recentTracks = presenter?.recentTracks else { return 0 }
            
            return recentTracks.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderView.identifier) as? HomeSectionHeaderView else { return nil }
        header.backgroundView = UIView()
        header.backgroundView?.backgroundColor = .bgColor
        switch section {
        case 0: 
            header.configure(title: "Latest Releases")
            return header
        case 1: 
            header.configure(title: "Recently Played")
            return header
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewReleasesSectionView.identifier, for: indexPath) as? NewReleasesSectionView else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: .init(albums: presenter?.latestAlbums ?? []))
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyPlayedCellView.identifier, for: indexPath) as? RecentlyPlayedCellView else {
                return UITableViewCell()
            }
            
            // Loading cell
            guard let recentTracks = presenter?.recentTracks, !recentTracks.isEmpty else {
                return UITableViewCell()
            }
            
            let currentTrack = recentTracks[indexPath.row]
            
            let cellViewModel = RecentlyPlayedCellViewModel(name: currentTrack.name, artists: currentTrack.artists.map { $0.name }, duration: TimeInterval(integerLiteral: Int64(currentTrack.duration/1000)).minuteSecond, imageUrl: currentTrack.album?.images.getImageUrl(for: .medium) ?? "")
            cell.configure(viewModel: cellViewModel)
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 260
        case 1: return 96
        default: return 0
        }
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func didTapOnAlbum(album: Album) {
        let albumDetailViewController = AlbumDetailViewController()
        let albumDetailModel = AlbumDetailModel(album: album)
        let presenter = AlbumDetailPresenter(view: albumDetailViewController, model: albumDetailModel)
        albumDetailViewController.presenter = presenter
        
        self.navigationController?.pushViewController(albumDetailViewController, animated: true)
    }
    
    func didReceiveNewReleases() {
        tableView.reloadData()
    }
    
    func didReceiveRecentTracks() {
        tableView.reloadData()
    }
}


