import Foundation

protocol AuthPresenterProtocol: AnyObject {
    func viewLoaded()
    func authenticate(authCode: String)
}

class AuthPresenter {
    weak var view: AuthViewControllerProtocol?
    var model: AuthModel
    
    init(view: AuthViewControllerProtocol, model: AuthModel) {
        self.view = view
        self.model = model
    }
}

extension AuthPresenter: AuthPresenterProtocol {
    func viewLoaded() { 
        model.delegate = self
    }
    
    func authenticate(authCode: String) {
        model.authenticate(authCode: authCode)
    }
}

extension AuthPresenter: AuthModelDelegate {
    func didReceiveAccessToken(isSuccess: Bool) {
        view?.authResponseReceived(isSuccess: isSuccess)
    }
}
