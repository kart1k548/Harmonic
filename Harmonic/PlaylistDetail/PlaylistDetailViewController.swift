import Foundation
import UIKit

protocol PlaylistDetailViewControllerProtocol: AnyObject {
    func didReceivePlaylistTracks()
}

class PlaylistDetailViewController: UIViewController {
    var presenter: PlaylistDetailPresenterProtocol?
    
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
        setupLeftBarButtonItem()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupLeftBarButtonItem() {
        let backButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        backButton.makeButton(with: UIImage(systemName: "arrow.left", withConfiguration: config), width: 24, height: 24, tintColor: .silverGrey)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupTableView() {
        tableView.register(PlaylistInfoViewCell.self, forCellReuseIdentifier: PlaylistInfoViewCell.identifier)
        tableView.register(PlaylistTrackViewCell.self, forCellReuseIdentifier: PlaylistTrackViewCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension PlaylistDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            guard let playlistTracks = presenter?.playlistTracks else { return 0 }
            
            return playlistTracks.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistInfoViewCell.identifier, for: indexPath) as? PlaylistInfoViewCell else { return UITableViewCell() }
            guard let presenter else { return UITableViewCell() }
            
            let viewModel = PlaylistInfoCellViewModel(name: presenter.playlistName,
                                                      description: presenter.playlistDescription,
                                                      totalTracks: presenter.playlistTracks.count,
                                                      imageUrl: presenter.playlistImageUrl)
            cell.delegate = self
            cell.configure(viewModel: viewModel)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTrackViewCell.identifier, for: indexPath) as? PlaylistTrackViewCell else { return UITableViewCell() }
            guard let track = presenter?.playlistTracks[indexPath.row] else { return UITableViewCell() }
            
            let viewModel = PlaylistTrackCellViewModel(name: track.name,
                                                       imageUrl: track.album?.images.getImageUrl(for: .low) ?? "",
                                                       artists: track.artists.map { $0.name },
                                                       duration: TimeInterval(integerLiteral: Int64(track.duration/1000)).minuteSecond)
            cell.configure(viewModel: viewModel)
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let track = presenter?.playlistTracks[indexPath.row] else { return }
        
        PlaybackManager.presentPlayer(from: self, track: track)
    }
}

extension PlaylistDetailViewController: PlaylistDetailViewControllerProtocol {
    func didReceivePlaylistTracks() {
        tableView.reloadData()
    }
}

extension PlaylistDetailViewController: PlaylistInfoViewCellDelegate {
    func didTapPlayButton() {
        PlaybackManager.presentPlayer(from: self, tracks: presenter?.playlistTracks ?? [])
    }
    
    func didTapShareButton(button: UIButton) {
        let activityController = UIActivityViewController(activityItems: [presenter?.playlistShareUrl ?? ""], applicationActivities: [])
        activityController.popoverPresentationController?.sourceView = button
        present(activityController, animated: true)
    }
}
