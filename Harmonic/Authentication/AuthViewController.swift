import UIKit
import WebKit

protocol AuthViewControllerProtocol: AnyObject {
    func authResponseReceived(isSuccess: Bool)
    func didRefreshAccessToken(isSuccess: Bool)
}

class AuthViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    var presenter: AuthPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .bgColor
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        loadWebView()
        presenter?.viewLoaded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func loadWebView() {
        let queryItems = [
            "response_type": "code",
            "client_id": APIConstans.clientID,
            "scope": APIConstans.scopes,
            "redirect_uri": APIConstans.redirectUri
        ]
        
        let requestConfig = RequestConfig(httpMethod: .get, host: APIConstans.signInBaseUrl, pathComponents: ["authorize"], queryItems: queryItems)
        guard let request = URLRequest(config: requestConfig) else { return }
        webView.load(request)
    }
}

extension AuthViewController: AuthViewControllerProtocol {
    func didRefreshAccessToken(isSuccess: Bool) {
        if isSuccess {
            print("access token refreshed")
        } else {
            print("access token failed to refresh")
        }
    }
    
    func authResponseReceived(isSuccess: Bool) {
        if isSuccess {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            print("Authentication Failed")
        }
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        let urlComponents = URLComponents(string: url.absoluteString)
        
        guard let code = urlComponents?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        
        webView.isHidden = true
        
        presenter?.authenticate(authCode: code)
    }
}
