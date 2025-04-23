import UIKit

class PlaylistCellView: UITableViewCell {
    static let identifier = "PlaylistCellView"

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            trackImageView,
            nameLabel
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 8, alignment: .center)
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .semibold, size: 16))
        label.numberOfLines = 2
        
        return label
    }()

    private lazy var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(bgColor: .lightPurple, width: 60, height: 60, cornerRadius: 5, clipsToBounds: true)
        
        return imageView
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .bgColor
        addToContentView(view: stackView, top: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: PlaylistCellViewModel) {
        trackImageView.loadImage(with: viewModel.imageUrl)
        nameLabel.text = viewModel.name
    }
}
