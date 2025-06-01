import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func didTapPreviousButton()
    func didTapPlayPauseButton(shouldPause: Bool)
    func didTapForwardButton()
}

final class PlayerControlsView: UIView {
    private var isTrackPaused: Bool = false
    weak var delegate: PlayerControlsViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonStackView
        ])
        stackView.makeStackView(axis: .vertical)
        
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            previousButton,
            playButton,
            forwardButton
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 32, distribution: .equalSpacing, alignment: .center)
        
        return stackView
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        button.makeButton(with: UIImage(systemName: "backward.end", withConfiguration: config),
                          width: 64,
                          height: 64,
                          tintColor: .silverGrey)
        button.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        button.makeButton(with: UIImage(systemName: "pause.fill", withConfiguration: config),
                          bgColor: .lightPurple,
                          width: 64,
                          height: 64,
                          cornerRadius: 32,
                          tintColor: .white)
        button.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        button.makeButton(with: UIImage(systemName: "forward.end", withConfiguration: config),
                          width: 64,
                          height: 64,
                          tintColor: .silverGrey)
        button.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .nunitoSemiBold18)
        
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        add(view: buttonStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getPlayButtonImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        return UIImage(systemName: isTrackPaused ? "play.fill" : "pause.fill", withConfiguration: config)
    }
    
    @objc func didTapPreviousButton() {
        delegate?.didTapPreviousButton()
    }
    
    @objc func didTapPlayPauseButton() {
        isTrackPaused.toggle()
        delegate?.didTapPlayPauseButton(shouldPause: isTrackPaused)
        playButton.setImage(getPlayButtonImage(), for: .normal)
    }
    
    @objc func didTapForwardButton() {
        delegate?.didTapForwardButton()
    }
}
