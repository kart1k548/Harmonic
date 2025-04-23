import Foundation
import UIKit

class NewReleasesSectionView: UITableViewCell {
    static let identifier = "NewReleasesSectionView"
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        collectionView.frame = self.frame
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .bgColor
        
        return collectionView
    }()
    
    private var viewModel: NewReleasesSectionViewModel?
    weak var delegate: HomeViewControllerProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView.register(NewReleasesCellView.self, forCellWithReuseIdentifier: NewReleasesCellView.identifier)
        addToContentView(view: collectionView)
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let carouselItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        carouselItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 12)
        
        let carouselGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(260)), subitems: [carouselItem])
        
        let carouselSection = NSCollectionLayoutSection(group: carouselGroup)
        carouselSection.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: carouselSection)
        
        return layout
    }
    
    func configure(with viewModel: NewReleasesSectionViewModel) {
        self.viewModel = viewModel
        self.collectionView.reloadData()
    }
}

extension NewReleasesSectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.albums.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCellView.identifier, for: indexPath) as? NewReleasesCellView else {
            fatalError("NewReleasesCellView is not a collection view cell")
        }
        
        guard let album = viewModel?.albums[indexPath.row] else {
            fatalError("No data for cell")
        }
        
        let viewModel = NewReleasesCellViewModel(name: album.name, artists: album.artists.map{ $0.name }, imageUrl: album.images.getImageUrl(for: .low))
        
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = viewModel?.albums[indexPath.row] else {
            fatalError("No data for cell")
        }
        
        delegate?.didTapOnAlbum(album: album)
    }
}
