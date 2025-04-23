import UIKit

protocol AlbumInfoViewCellDelegate: AnyObject {
    func didTapShareButton(button: UIButton)
}

class AlbumInfoViewCell: UITableViewCell {
    static let identifier = "AlbumInfoViewCell"
    
    private lazy var stackView: UIStackView = {
        let spacer = UIView()
        spacer.makeSpacerView(height: 16)
        let stackView = UIStackView(arrangedSubviews: [
            albumImageView,
            nameLabel,
            releaseDateLabel,
            buttonStackView,
            spacer
        ])
        stackView.makeStackView(axis: .vertical, spacing: 8, distribution: .equalSpacing, alignment: .center)
        
        return stackView
    }()
    
    private lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(bgColor: .lightPurple, width: 240, height: 240, cornerRadius: 20, clipsToBounds: true)
        
        return imageView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            downloadButton,
            playButton,
            shareButton
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 32, distribution: .equalSpacing, alignment: .center)
        
        return stackView
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .medium)
        button.makeButton(with: UIImage(systemName: "arrow.down.to.line", withConfiguration: config),
                          bgColor: .lightGray.withAlphaComponent(0.2),
                          width: 40,
                          height: 40,
                          cornerRadius: 20,
                          tintColor: .silverGrey)
        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .medium)
        button.makeButton(with: UIImage(systemName: "play.fill", withConfiguration: config),
                          bgColor: .lightPurple,
                          width: 64,
                          height: 64,
                          cornerRadius: 32,
                          tintColor: .white)
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .medium)
        button.makeButton(with: UIImage(systemName: "square.and.arrow.up", withConfiguration: config),
                          bgColor: .lightGray.withAlphaComponent(0.2),
                          width: 40,
                          height: 40,
                          cornerRadius: 20,
                          tintColor: .silverGrey)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center, textFont: .getCustomSizedFont(fontWeight: .regular, size: 18))
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 24))
        label.numberOfLines = 2
        
        return label
    }()
    
    weak var delegate: AlbumInfoViewCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .bgColor
        addToContentView(view: stackView)
    }
    
    @objc func didTapPlayButton() {
        //TODO: Implement play button tap
    }
    
    @objc func didTapDownloadButton() {
        //TODO: Implement download button tap functionality
    }
    
    @objc func didTapShareButton(_ sender: UIButton) {
        delegate?.didTapShareButton(button: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: AlbumInfoCellViewModel) {
        albumImageView.loadImage(with: viewModel.imageUrl)
        nameLabel.text = viewModel.name
        releaseDateLabel.text = "\(viewModel.artists)  \u{2022}  \(viewModel.releaseDate)"
    }
}
