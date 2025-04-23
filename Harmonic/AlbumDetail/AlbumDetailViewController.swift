import Foundation
import UIKit

protocol AlbumDetailViewControllerProtocol: AnyObject {
    func didReceiveAlbumTracks()
    func didCheckSavedAlbum()
    func didSaveAlbum()
    func didRemoveSavedAlbum()
}

class AlbumDetailViewController: UIViewController {
    var presenter: AlbumDetailPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgColor
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var heartButton: UIButton = {
        let heartButton = UIButton()
        heartButton.makeButton(with: getHeartImage(), width: 32, height: 24, tintColor: .silverGrey)
        heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        heartButton.isEnabled = false
        
        return heartButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bgColor
        setupNavBar()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    func setupNavBar() {
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
    }
    
    private func setupLeftBarButtonItem() { 
        let backButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        backButton.makeButton(with: UIImage(systemName: "arrow.left", withConfiguration: config), width: 24, height: 24, tintColor: .silverGrey)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    }
    
    func setupTableView() {
        tableView.register(AlbumInfoViewCell.self, forCellReuseIdentifier: AlbumInfoViewCell.identifier)
        tableView.register(AlbumTrackViewCell.self, forCellReuseIdentifier: AlbumTrackViewCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    func getHeartImage(isAlbumSaved: Bool = false) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        return UIImage(systemName: isAlbumSaved ? "heart.fill" : "heart", withConfiguration: config)
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapHeartButton() {
        presenter?.heartButtonTapped()
    }
}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            guard let albumTracks = presenter?.albumTracks else { return 0 }
            
            return albumTracks.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoViewCell.identifier, for: indexPath) as? AlbumInfoViewCell else { return UITableViewCell() }
            guard let presenter else { return UITableViewCell() }
            
            let viewModel = AlbumInfoCellViewModel(name: presenter.albumName, 
                                                   artists: presenter.artists,
                                                   releaseDate: presenter.releaseDate,
                                                   imageUrl: presenter.albumImageUrl)
            cell.delegate = self
            cell.configure(viewModel: viewModel)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTrackViewCell.identifier, for: indexPath) as? AlbumTrackViewCell else { return UITableViewCell() }
            guard let track = presenter?.albumTracks[indexPath.row] else { return UITableViewCell() }
            
            let viewModel = AlbumTrackCellViewModel(name: track.name, 
                                                    currentRow: "\(indexPath.row + 1)",
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
}

extension AlbumDetailViewController: AlbumDetailViewControllerProtocol {
    func didCheckSavedAlbum() {
        if let isSavedAlbum = presenter?.isSavedAlbum {
            heartButton.setImage(getHeartImage(isAlbumSaved: presenter?.isSavedAlbum ?? false), for: .normal)
            heartButton.tintColor = isSavedAlbum ? .red : .silverGrey
            heartButton.isEnabled = true
        }
    }
    
    func didSaveAlbum() {
        heartButton.setImage(getHeartImage(isAlbumSaved: true), for: .normal)
        heartButton.tintColor = .red
    }
    
    func didRemoveSavedAlbum() {
        heartButton.setImage(getHeartImage(), for: .normal)
        heartButton.tintColor = .silverGrey
    }
    
    func didReceiveAlbumTracks() {
        tableView.reloadData()
    }
}

extension AlbumDetailViewController: AlbumInfoViewCellDelegate {
    func didTapShareButton(button: UIButton) {
        let activityController = UIActivityViewController(activityItems: [presenter?.albumShareUrl ?? ""], applicationActivities: [])
        activityController.popoverPresentationController?.sourceView = button
        present(activityController, animated: true)
    }
}
