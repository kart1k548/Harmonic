import UIKit

class SettingsViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            profileStackView,
            downloadsButtonView,
            historyButtonView,
            logoutButtonView
        ])
        stackView.makeStackView(axis: .vertical, spacing: 32)
        
        return stackView
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageView,
            profileLabelsStackView
        ])
        stackView.makeStackView(axis: .horizontal, spacing: 16, height: 150)
        
        return stackView
    }()
    
    private lazy var profileLabelsStackView: UIStackView = {
        let nameLabel = UILabel()
        nameLabel.makeLabel(with: profile?.name ?? "".capitalized, textColor: .white, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 18))
        let accountType = UILabel()
        accountType.makeLabel(with: "\(profile?.product ?? "") Member".capitalized, textColor: .lightGray, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 16))
        let emailLabel = UILabel()
        emailLabel.makeLabel(with: profile?.email ?? "", textColor: .lightGray, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 16))
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            accountType,
            emailLabel
        ])
        stackView.makeStackView(axis: .vertical, spacing: 8, distribution: .fillProportionally)
        
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .semibold, scale: .large)
        let image = UIImage(systemName: "\(profile?.name.first ?? "a")".lowercased(), withConfiguration: config)
        imageView.makeImageView(image: image, bgColor: .lightPurple, tintColor: .white, width: 150, cornerRadius: 30)
        imageView.contentMode = .center
        if let imageUrl = profile?.images.first?.url {
            imageView.loadImage(with: imageUrl)
        }
        
        return imageView
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.makeLabel(with: "SETTINGS", textColor: .silverGrey, textFont: .getCustomSizedFont(fontWeight: .extrabold, size: 24))
        
        return label
    }()
    
    private lazy var downloadsButtonView: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let view = makeSettingsCellView(image: UIImage(systemName: "arrow.down.circle"), text: "Downloads")
        view.isUserInteractionEnabled = false
        button.add(view: view)
        
        return button
    }()
    
    private lazy var historyButtonView: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let view = makeSettingsCellView(image: UIImage(systemName: "clock"), text: "History")
        view.isUserInteractionEnabled = false
        button.add(view: view)
        
        return button
    }()
    
    private lazy var logoutButtonView: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let view = makeSettingsCellView(image: UIImage(systemName: "door.right.hand.open"), text: "Logout")
        view.isUserInteractionEnabled = false
        button.add(view: view)
        
        return button
    }()
    
    var profile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .bgColor
        setupStackView()
        setupButtonTargets()
        self.navigationItem.titleView = navigationTitle
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupButtonTargets() {
        downloadsButtonView.addTarget(self, action: #selector(downloadsTapped), for: .touchUpInside)
        historyButtonView.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
        logoutButtonView.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    private func makeSettingsCellView(image: UIImage?, text: String) -> UIView {
        let imageView = UIImageView()
        imageView.makeImageView(image: image, tintColor: .lightestPurple, width: 34)
        
        let label = UILabel()
        label.makeLabel(with: text, textColor: .silverGrey, textFont: .getCustomSizedFont(fontWeight: .semibold, size: 22))
        
        let cellStackView = UIStackView(arrangedSubviews: [
            imageView,
            label
        ])
        cellStackView.makeStackView(axis: .horizontal, spacing: 16)
        
        return cellStackView
    }
    
    @objc func downloadsTapped() {
        //TODO: Implement downloads functionality
    }
    
    @objc func historyTapped() {
        //TODO: Implement history screens
    }
    
    @objc func logoutTapped() {
        //TODO: Implement logout functionality
    }
}
