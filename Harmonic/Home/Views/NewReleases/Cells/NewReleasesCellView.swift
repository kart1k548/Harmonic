import Foundation
import UIKit

class NewReleasesCellView: UICollectionViewCell {
    static let identifier = "NewReleasesCellView"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            labelStackView
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 8)
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            artistsLabel
        ])
        stackView.makeStackView(axis: .vertical, distribution: .fillProportionally)
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(bgColor: .lightPurple, width: 70, cornerRadius: 5, clipsToBounds: true)
        
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
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addToContentView(view: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: NewReleasesCellViewModel) {
        imageView.loadImage(with: viewModel.imageUrl ?? "")
        nameLabel.text = viewModel.name
        artistsLabel.text = viewModel.artists.joined(separator: " & ")
    }
}
