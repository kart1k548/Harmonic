import UIKit

protocol SearchFilterViewDelegate: AnyObject {
    func didTapSongsFilter()
    func didTapAlbumsFilter()
    func didTapPlaylistsFilter()
    func didTapArtistsFilter()
    func dismissAppliedFilter()
}

enum Filter {
    case songs
    case albums
    case playlists
    case artists
    case none
}

class SearchFilterView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            songFilterButton,
            albumFilterButton,
            playlistFilterButton,
            artistFilterButton
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 16, height: 40)
        
        return stackView
    }()
    
    private lazy var songFilterButton: UIButton = {
        let button = UIButton()
        button.makeButton(with: "Songs".uppercased(),
                          textColor: .silverGrey,
                          textFont: .nunitoRegular14,
                          width: 72,
                          cornerRadius: 18,
                          bgColor: .clear)
        button.addTarget(self, action: #selector(didTapSongsFilter), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var albumFilterButton: UIButton = {
        let button = UIButton()
        button.makeButton(with: "Albums".uppercased(),
                          textColor: .silverGrey,
                          textFont: .nunitoRegular14,
                          width: 72,
                          cornerRadius: 18,
                          bgColor: .clear)
        button.addTarget(self, action: #selector(didTapAlbumsFilter), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var playlistFilterButton: UIButton = {
        let button = UIButton()
        button.makeButton(with: "Playlists".uppercased(),
                          textColor: .silverGrey,
                          textFont: .nunitoRegular14,
                          width: 88,
                          cornerRadius: 22,
                          bgColor: .clear)
        button.addTarget(self, action: #selector(didTapPlaylistsFilter), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var artistFilterButton: UIButton = {
        let button = UIButton()
        button.makeButton(with: "Artists".uppercased(),
                          textColor: .silverGrey,
                          textFont: .nunitoRegular14,
                          width: 72,
                          cornerRadius: 18,
                          bgColor: .clear)
        button.addTarget(self, action: #selector(didTapArtistsFilter), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: SearchFilterViewDelegate?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .bgColor
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapSongsFilter() {
        if songFilterButton.backgroundColor == .clear {
            songFilterButton.backgroundColor = .lightPurple
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                albumFilterButton.isHidden = true
                playlistFilterButton.isHidden = true
                artistFilterButton.isHidden = true
            }
            delegate?.didTapSongsFilter()
        } else {
            songFilterButton.backgroundColor = .clear
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                albumFilterButton.isHidden = false
                playlistFilterButton.isHidden = false
                artistFilterButton.isHidden = false
            }
            delegate?.dismissAppliedFilter()
        }
    }
    
    @objc func didTapAlbumsFilter() {
        if albumFilterButton.backgroundColor == .clear {
            albumFilterButton.backgroundColor = .lightPurple
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                songFilterButton.isHidden = true
                playlistFilterButton.isHidden = true
                artistFilterButton.isHidden = true
            }
            delegate?.didTapAlbumsFilter()
        } else {
            albumFilterButton.backgroundColor = .clear
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                songFilterButton.isHidden = false
                playlistFilterButton.isHidden = false
                artistFilterButton.isHidden = false
            }
            delegate?.dismissAppliedFilter()
        }
    }
    
    @objc func didTapPlaylistsFilter() {
        if playlistFilterButton.backgroundColor == .clear {
            playlistFilterButton.backgroundColor = .lightPurple
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                albumFilterButton.isHidden = true
                songFilterButton.isHidden = true
                artistFilterButton.isHidden = true
            }
            delegate?.didTapPlaylistsFilter()
        } else {
            playlistFilterButton.backgroundColor = .clear
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                albumFilterButton.isHidden = false
                songFilterButton.isHidden = false
                artistFilterButton.isHidden = false
            }
            delegate?.dismissAppliedFilter()
        }
    }
    
    @objc func didTapArtistsFilter() {
        if artistFilterButton.backgroundColor == .clear {
            artistFilterButton.backgroundColor = .lightPurple
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                albumFilterButton.isHidden = true
                playlistFilterButton.isHidden = true
                songFilterButton.isHidden = true
            }
            delegate?.didTapArtistsFilter()
        } else {
            artistFilterButton.backgroundColor = .clear
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                albumFilterButton.isHidden = false
                playlistFilterButton.isHidden = false
                songFilterButton.isHidden = false
            }
            delegate?.dismissAppliedFilter()
        }
    }
}
