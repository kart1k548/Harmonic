import UIKit

protocol SearchViewControllerProtocol: AnyObject{
    func didReceiveCategories()
}

class SearchViewController: UIViewController {
    private lazy var searchController: UISearchController = {
        let results = SearchResultsViewController()
        results.delegate = self
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Search, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        vc.searchBar.tintColor = .silverGrey
        vc.searchBar.searchTextField.textColor = .silverGrey
        vc.searchBar.searchTextField.font = .getCustomSizedFont(fontWeight: .regular, size: 16)
        vc.obscuresBackgroundDuringPresentation = false
        vc.searchBar.delegate = self
        vc.searchBar.barStyle = .black
        vc.automaticallyShowsSearchResultsController = true
        vc.showsSearchResultsController = true
        
        return vc
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.makeLabel(with: "BROWSE", textColor: .silverGrey, textFont: .getCustomSizedFont(fontWeight: .extrabold, size: 24))
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .bgColor
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    var presenter: SearchPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bgColor
        searchController.searchResultsUpdater = self
        setupNavBar()
        
        presenter?.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        view.add(view: collectionView, left: 8, right: -16)
    }
    
    func setupNavBar() {
        let backButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        backButton.makeButton(with: UIImage(systemName: "arrow.left", withConfiguration: config), width: 24, height: 24, tintColor: .silverGrey)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        navigationItem.titleView = navigationTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let carouselItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        carouselItem.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0)
        
        let carouselGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110)), subitems: [carouselItem])
        
        let carouselSection = NSCollectionLayoutSection(group: carouselGroup)
        
        let layout = UICollectionViewCompositionalLayout(section: carouselSection)
        
        return layout
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) { }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        if let presenter = searchController.presenter {
            presenter.searchText = query
        } else {
            let resultsModel = SearchResultsModel()
            resultsModel.searchText = query
            let searchResultsPresenter = SearchResultsPresenter(view: searchController, model: resultsModel)
            searchController.presenter = searchResultsPresenter
            resultsModel.getSearch()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.musicCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        guard let category = presenter?.musicCategories[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(viewModel: CategoryCollectionCellViewModel(name: category.name, imageUrl: category.icons.getImageUrl(for: .medium)))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = presenter?.musicCategories[indexPath.row] else { return }
        
        let playlistCollectionVC = PlaylistCollectionViewController()
        let model = PlaylistCollectionModel(searchText: category.name)
        let playlistPresenter = PlaylistCollectionPresenter(view: playlistCollectionVC, model: model)
        playlistCollectionVC.presenter = playlistPresenter
        
        navigationController?.pushViewController(playlistCollectionVC, animated: true)
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    func didReceiveCategories() {
        collectionView.reloadData()
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didSelectTrack(track: TrackDetail) {
        PlaybackManager.presentPlayer(from: self, track: track)
    }
    
    func didSelectAlbum(album: Album) {
        let albumDetailViewController = AlbumDetailViewController()
        let albumDetailModel = AlbumDetailModel(album: album)
        let presenter = AlbumDetailPresenter(view: albumDetailViewController, model: albumDetailModel)
        albumDetailViewController.presenter = presenter
        
        navigationController?.pushViewController(albumDetailViewController, animated: true)
    }
    
    func didSelectPlaylist(playlist: Playlist) {
        let playlistDetailVC = PlaylistDetailViewController()
        let model = PlaylistDetailModel(playlist: playlist)
        let playlistDetailPresenter = PlaylistDetailPresenter(view: playlistDetailVC, model: model)
        playlistDetailVC.presenter = playlistDetailPresenter
        
        navigationController?.pushViewController(playlistDetailVC, animated: true)
    }
}
