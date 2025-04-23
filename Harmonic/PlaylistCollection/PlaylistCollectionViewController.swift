import UIKit

protocol PlaylistCollectionViewControllerProtocol: AnyObject{
    func didReceivePlaylists()
}

class PlaylistCollectionViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .bgColor
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.makeLabel(with: "PLAYLISTS", textColor: .silverGrey, textFont: .getCustomSizedFont(fontWeight: .extrabold, size: 24))
        
        return label
    }()
    
    var presenter: PlaylistCollectionPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bgColor
        setupNavBar()
        
        presenter?.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(PlaylistCollectionCellView.self, forCellWithReuseIdentifier: PlaylistCollectionCellView.identifier)
        view.add(view: collectionView, left: 8, right: -16)
    }
    
    func setupNavBar() {
        let backButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        backButton.makeButton(with: UIImage(systemName: "arrow.left", withConfiguration: config), width: 24, height: 24, tintColor: .silverGrey)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        navigationItem.titleView = navigationTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let carouselItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        carouselItem.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0)
        
        let carouselGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240)), subitems: [carouselItem])
        
        let carouselSection = NSCollectionLayoutSection(group: carouselGroup)
        
        let layout = UICollectionViewCompositionalLayout(section: carouselSection)
        
        return layout
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension PlaylistCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.receivedPlaylists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionCellView.identifier, for: indexPath) as? PlaylistCollectionCellView else { return UICollectionViewCell() }
        guard let playlist = presenter?.receivedPlaylists[indexPath.row] else { return UICollectionViewCell() }
        cell.configure(viewModel: PlaylistCollectionCellViewModel(name: playlist.name, imageUrl: playlist.images.getImageUrl(for: .medium) ?? "", ownerName: playlist.owner.displayName))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let playlist = presenter?.receivedPlaylists[indexPath.row] else { return }
        
        let playlistDetailVC = PlaylistDetailViewController()
        let model = PlaylistDetailModel(playlist: playlist)
        let playlistDetailPresenter = PlaylistDetailPresenter(view: playlistDetailVC, model: model)
        playlistDetailVC.presenter = playlistDetailPresenter
        
        navigationController?.pushViewController(playlistDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let playlists = presenter?.receivedPlaylists, playlists.count == indexPath.row + 1 {
            print("Load moreee......")
        }
    }
}

extension PlaylistCollectionViewController: PlaylistCollectionViewControllerProtocol {
    func didReceivePlaylists() {
        collectionView.reloadData()
    }
}
