import Foundation
import UIKit

class HomeNavigationView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageView,
            labelStackView
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 8)
        
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            accountType
        ])
        stackView.makeStackView(axis: .vertical, distribution: .fillProportionally)
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .nunitoSemiBold18)
        
        return label
    }()
    
    private lazy var accountType: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .nunitoRegular14)
        
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "person.circle.fill")
        imageView.makeImageView(image: image, bgColor: .lightPurple, tintColor: .bgColor, width: 40, height: 40, cornerRadius: 20)
        
        return imageView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        add(view: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: HomeNavigationViewModel) {
        profileImageView.loadImage(with: viewModel.photoUrl)
        nameLabel.text = viewModel.name
        accountType.text = viewModel.accountType
    }
}
