import Foundation
import UIKit

class RecentlyPlayedCellView: UITableViewCell {
    static let identifier = "RecentlyPlayedCellView"
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            trackImageView,
            labelStackView
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 8)
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            artistsLabel,
            durationLabel
        ])
        stackView.makeStackView(axis: .vertical, distribution: .fillProportionally)
        
        return stackView
    }()
    
    private lazy var trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(bgColor: .lightPurple, width: 80, cornerRadius: 10, clipsToBounds: true)
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .regular, size: 18))
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var artistsLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .regular, size: 13))
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .regular, size: 13))
        label.numberOfLines = 2
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .bgColor
        addToContentView(view: contentStackView, top: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: RecentlyPlayedCellViewModel) {
        nameLabel.text = viewModel.name
        trackImageView.loadImage(with: viewModel.imageUrl)
        artistsLabel.text = viewModel.artists.joined(separator: " & ")
        durationLabel.text = viewModel.duration
    }
}
