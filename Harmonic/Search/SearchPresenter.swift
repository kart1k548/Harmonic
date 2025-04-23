import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var musicCategories: [Category] { get }
    func viewDidLoad()
}

class SearchPresenter {
    weak var view: SearchViewControllerProtocol?
    var model: SearchModel
    
    init(view: SearchViewControllerProtocol, model: SearchModel) {
        self.view = view
        self.model = model
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    var musicCategories: [Category] {
        model.categories
    }
    
    func viewDidLoad() {
        model.delegate = self
        model.getCategories()
    }
}

extension SearchPresenter: SearchModelDelegate {    
    func didReceiveCategories() {
        view?.didReceiveCategories()
    }
}
