import UIKit

class SignInViewController: UIViewController {
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.makeButton(with: "Sign In".uppercased(), 
                          textColor: .lightestGrey,
                          textFont: .nunitoSemiBold22,
                          cornerRadius: 25,
                          bgColor: .lightestPurple)
        
        return button
    }()
    
    private lazy var navigationTitle: UILabel = {
        let label = UILabel()
        label.makeLabel(with: "Harmonic", textColor: .silverGrey, textFont: .getCustomSizedFont(fontWeight: .extrabold, size: 36))
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        navigationItem.titleView = navigationTitle
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
    }
    
    @objc func didTapSignIn() {
        let authViewController = AuthViewController()
        authViewController.navigationItem.largeTitleDisplayMode = .never
        let model = AuthModel()
        model.completionHandler = { [weak self] success in
            self?.handleSignIn(isSuccessful: success)
        }
        authViewController.presenter = AuthPresenter(view: authViewController, model: model)
        navigationController?.pushViewController(authViewController, animated: true)
    }
    
    private func handleSignIn(isSuccessful: Bool) {
        guard isSuccessful else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let tabBarViewController = TabBarViewController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        tabBarViewController.presenter = TabBarPresenter(view: tabBarViewController)
        
        present(tabBarViewController, animated: true)
    }
}

