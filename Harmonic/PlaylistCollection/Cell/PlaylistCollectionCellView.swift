import UIKit

class PlaylistCollectionCellView: UICollectionViewCell {
    static let identifier = "PlaylistCollectionCellView"
    
    private lazy var stackView: UIStackView = {
        let spacer = UIView()
        spacer.makeSpacerView(height: 16)
        let stackView = UIStackView(arrangedSubviews: [
            playlistImageView,
            nameLabel,
            ownerLabel
        ])
        stackView.makeStackView(axis: .vertical, spacing: 8, distribution: .equalSpacing, alignment: .center)
        
        return stackView
    }()
    
    private lazy var playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(bgColor: .lightPurple, cornerRadius: 20, clipsToBounds: true)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center, textFont: .getCustomSizedFont(fontWeight: .regular, size: 18))
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        return label
    }()
    
    private lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(alignment: .center, textFont: .getCustomSizedFont(fontWeight: .regular, size: 13))
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addToContentView(view: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: PlaylistCollectionCellViewModel) {
        playlistImageView.loadImage(with: viewModel.imageUrl)
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
    }
}
