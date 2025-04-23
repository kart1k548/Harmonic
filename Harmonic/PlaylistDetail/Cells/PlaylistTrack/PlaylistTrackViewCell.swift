import UIKit

class PlaylistTrackViewCell: UITableViewCell {
    static let identifier = "PlaylistTrackViewCell"

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            trackImageView,
            labelStackView
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 8, alignment: .center)
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            artistsLabel
        ])
        stackView.makeStackView(axis: .vertical, spacing: 2, distribution: .equalSpacing)
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .semibold, size: 16))
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var artistsLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .regular, size: 14))
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
    
    public func configure(viewModel: PlaylistTrackCellViewModel) {
        nameLabel.text = viewModel.name
        trackImageView.loadImage(with: viewModel.imageUrl)
        artistsLabel.text = viewModel.artists.joined(separator: " & ") + " \u{2022} \(viewModel.duration)"
    }
}
