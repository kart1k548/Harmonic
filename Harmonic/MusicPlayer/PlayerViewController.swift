import UIKit

protocol PlayerViewControllerProtocol: AnyObject {
    func didCheckSavedTrack()
    func didSaveTrack()
    func didRemoveSavedTrack()
}

class PlayerViewController: UIViewController {
    var presenter: PlayerPresenterProtocol?
    
    private lazy var stackView: UIStackView = {
        let spacer = UIView()
        spacer.makeSpacerView(height: 16)
        let stackView = UIStackView(arrangedSubviews: [
            trackImageView,
            trackNameLabel,
            artistsNameLabel,
            controlsView,
            spacer
        ])
        stackView.makeStackView(axis: .vertical, spacing: 8, distribution: .equalSpacing, alignment: .center)
        
        return stackView
    }()
    
    private lazy var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(bgColor: .lightPurple, width: 320, height: 320, cornerRadius: 40, clipsToBounds: true)
        if let albumImageUrl = presenter?.albumImageUrl {
            imageView.loadImage(with: albumImageUrl)
        }
        
        return imageView
    }()
    
    private lazy var heartButton: UIButton = {
        let heartButton = UIButton()
        heartButton.makeButton(with: getHeartImage(), width: 32, height: 24, tintColor: .silverGrey)
        heartButton.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        heartButton.isEnabled = false
        
        return heartButton
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 24))
        label.numberOfLines = 2
        label.text = presenter?.track.name ?? ""
        
        return label
    }()
    
    private lazy var artistsNameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center, textColor: .lightestGrey ?? .white, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 18))
        label.numberOfLines = 0
        label.text = presenter?.track.artists.map({ $0.name }).joined(separator: " & ")
        
        return label
    }()
    
    private lazy var controlsView: PlayerControlsView = {
        let controlsView = PlayerControlsView()
        return controlsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .bgColor
        setupNavBar()
        setupLayout()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controlsView.delegate = self
    }
    
    private func setupNavBar() {
        setupLeftBarButtonItem()
        setupRightBarButtonItem()
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            view.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32)
        ])
    }
    
    private func setupLeftBarButtonItem() {
        let backButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        backButton.makeButton(with: UIImage(systemName: "chevron.down", withConfiguration: config), width: 24, height: 24, tintColor: .silverGrey)
        backButton.addTarget(self, action: #selector(didTapArrowButton), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: heartButton)
    }
    
    private func getHeartImage(isTrackSaved: Bool = false) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold, scale: .medium)
        return UIImage(systemName: isTrackSaved ? "heart.fill" : "heart", withConfiguration: config)
    }
    
    @objc func didTapArrowButton() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func didTapHeartButton() {
        presenter?.heartButtonTapped()
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func didTapPreviousButton() {
        // TODO: Implement previous song button on tap logic
    }
    
    func didTapPlayPauseButton(shouldPause: Bool) {
        shouldPause ? presenter?.pauseSong() : presenter?.playSong()
    }
    
    func didTapForwardButton() {
        // TODO: Implement forward song button on tap logic
    }
}

extension PlayerViewController: PlayerViewControllerProtocol {
    func didCheckSavedTrack() {
        if let isTrackSaved = presenter?.isTrackSaved {
            heartButton.setImage(getHeartImage(isTrackSaved: isTrackSaved), for: .normal)
            heartButton.tintColor = isTrackSaved ? .red : .silverGrey
            heartButton.isEnabled = true
        }
    }
    
    func didSaveTrack() {
        heartButton.setImage(getHeartImage(isTrackSaved: true), for: .normal)
        heartButton.tintColor = .red
    }
    
    func didRemoveSavedTrack() {
        heartButton.setImage(getHeartImage(), for: .normal)
        heartButton.tintColor = .silverGrey
    }
}
