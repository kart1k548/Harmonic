import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private lazy var stackView: UIStackView = {
        let spacer = UIView()
        spacer.makeSpacerView(width: 8)
        let stackView = UIStackView(arrangedSubviews: [
            spacer,
            categoryNameLabel,
            imageViewWrapper
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 4, alignment: .top)
        
        return stackView
    }()
    
    private lazy var imageViewWrapper: UIStackView = {
        let topSpacer = UIView()
        topSpacer.makeSpacerView(height: 2)
        let bottomSpacer = UIView()
        bottomSpacer.makeSpacerView(height: 10)
        let stackView = UIStackView(arrangedSubviews: [
            topSpacer,
            imageView,
            bottomSpacer
        ])
        stackView.makeStackView(axis: .vertical)
        
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeImageView(width: 80, cornerRadius: 10, clipsToBounds: true)
        
        return imageView
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .getCustomSizedFont(fontWeight: .extrabold, size: 13))
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addToContentView(view: stackView, top: 8)
        contentView.backgroundColor = UIColor.getCategoryColor()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: CategoryCollectionCellViewModel) {
        imageView.loadImage(with: viewModel.imageUrl ?? "")
        categoryNameLabel.text = viewModel.name
    }
}
