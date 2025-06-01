import UIKit

protocol SearchResultsViewControllerProtocol: AnyObject {
    func didReceiveSearch()
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectTrack(track: TrackDetail)
    func didSelectAlbum(album: Album)
    func didSelectPlaylist(playlist: Playlist)
}

class SearchResultsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgColor
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var filtersView: SearchFilterView = {
        return SearchFilterView()
    }()
    
    var presenter: SearchResultsPresenterProtocol?
    
    weak var delegate: SearchResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupFiltersView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.isHidden = true
        filtersView.isHidden = true
        filtersView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func setupFiltersView() {
        view.addSubview(filtersView)
        
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filtersView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: filtersView.trailingAnchor, constant: 16),
            filtersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupTableView() {
        tableView.register(PlaylistTrackViewCell.self, forCellReuseIdentifier: PlaylistTrackViewCell.identifier)
        tableView.register(AlbumCellView.self, forCellReuseIdentifier: AlbumCellView.identifier)
        tableView.register(PlaylistCellView.self, forCellReuseIdentifier: PlaylistCellView.identifier)
        tableView.register(ArtistsCellView.self, forCellReuseIdentifier: ArtistsCellView.identifier)
        
        tableView.register(SearchResultsHeaderView.self, forHeaderFooterViewReuseIdentifier: SearchResultsHeaderView.identifier)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter else { return UITableViewCell() }
        let section = presenter.selectedFilter == .none ? indexPath.section : presenter.sectionIndx
        
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTrackViewCell.identifier, for: indexPath) as? PlaylistTrackViewCell else { return UITableViewCell() }
            let track = presenter.receivedTracks[indexPath.row]
            let viewModel = PlaylistTrackCellViewModel(name: track.name, imageUrl: track.album?.images.getImageUrl(for: .low) ?? "", artists: track.artists.map({ $0.name }), duration: TimeInterval(integerLiteral: Int64(track.duration/1000)).minuteSecond)
            cell.configure(viewModel: viewModel)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCellView.identifier, for: indexPath) as? AlbumCellView else { return UITableViewCell() }
            let album = presenter.receivedAlbums[indexPath.row]
            let viewModel = AlbumCellViewModel(name: album.name, imageUrl: album.images.getImageUrl(for: .low) ?? "", artists: album.artists.map { $0.name })
            cell.configure(with: viewModel)
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistCellView.identifier, for: indexPath) as? PlaylistCellView else { return UITableViewCell() }
            let playlist = presenter.receivedPlaylists[indexPath.row]
            let viewModel = PlaylistCellViewModel(name: playlist.name, imageUrl: playlist.images.getImageUrl(for: .low) ?? "")
            cell.configure(with: viewModel)
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistsCellView.identifier, for: indexPath) as? ArtistsCellView else { return UITableViewCell() }
            let artist = presenter.receivedArtists[indexPath.row]
            let viewModel = ArtistsCellViewModel(name: artist.name, imageUrl: artist.images?.getImageUrl(for: .low) ?? "")
            cell.configure(with: viewModel)
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchResultsHeaderView.identifier) as? SearchResultsHeaderView else { return nil }
        
        guard let presenter, presenter.selectedFilter == .none else { return nil }
        
        header.backgroundView = UIView()
        header.backgroundView?.backgroundColor = .bgColor
        
        switch section {
        case 0:
            header.configure(title: "Songs")
            return header
        case 1:
            header.configure(title: "Albums")
            return header
        case 2:
            header.configure(title: "Playlists")
            return header
        case 3:
            header.configure(title: "Artists")
            return header
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        let section = presenter.selectedFilter == .none ? indexPath.section : presenter.sectionIndx
        
        switch section {
        case 0:
            let track = presenter.receivedTracks[indexPath.row]
            delegate?.didSelectTrack(track: track)
        case 1:
            let album = presenter.receivedAlbums[indexPath.row]
            delegate?.didSelectAlbum(album: album)
        case 2:
            let playlist = presenter.receivedPlaylists[indexPath.row]
            delegate?.didSelectPlaylist(playlist: playlist)
        case 3: return
        default: return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter else { return 0 }
        return presenter.selectedFilter == .none ? 4 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        let sectionIndx = presenter.selectedFilter == .none ? section : presenter.sectionIndx
        
        switch sectionIndx {
        case 0: return presenter.receivedTracks.count
        case 1: return presenter.receivedAlbums.count
        case 2: return presenter.receivedPlaylists.count
        case 3: return presenter.receivedArtists.count
        default : return 0
        }
    }
}

extension SearchResultsViewController: SearchResultsViewControllerProtocol {
    func didReceiveSearch() {
        filtersView.isHidden = false
        tableView.isHidden = false
        tableView.reloadData()
    }
}

extension SearchResultsViewController: SearchFilterViewDelegate {
    func dismissAppliedFilter() {
        presenter?.selectedFilter = .none
    }
    
    func didTapSongsFilter() {
        presenter?.selectedFilter = .track
    }
    
    func didTapAlbumsFilter() {
        presenter?.selectedFilter = .album
    }
    
    func didTapPlaylistsFilter() {
        presenter?.selectedFilter = .playlist
    }
    
    func didTapArtistsFilter() {
        presenter?.selectedFilter = .artist
    }
}
