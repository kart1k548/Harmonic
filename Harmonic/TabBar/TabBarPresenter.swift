import Foundation

protocol TabBarPresenterProtocol: AnyObject {
    func viewWillAppear()
}

class TabBarPresenter {
    weak var view: TabBarViewControllerProtocol?
    var model: TabBarModel
    
    init(view: TabBarViewControllerProtocol, model: TabBarModel = TabBarModel()) {
        self.view = view
        self.model = model
    }
}

extension TabBarPresenter: TabBarPresenterProtocol {
    func viewWillAppear() {
        model.delegate = self
        model.getUserProfile()
    }
}

extension TabBarPresenter: TabBarModelDelegate {
    func didReceiveProfile(profile: UserProfile?) {
        view?.didReceiveProfile(profile: profile)
    }
}
