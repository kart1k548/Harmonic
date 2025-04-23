import Foundation

protocol HomePresenterProtocol: AnyObject {
    var userProfile: UserProfile? { get }
    var recentTracks: [TrackDetail] { get }
    var latestAlbums: [Album] { get }
    func viewDidLoad()
}

class HomePresenter {
    weak var view: HomeViewControllerProtocol?
    var model: HomeModel
    
    init(view: HomeViewControllerProtocol, model: HomeModel = HomeModel()) {
        self.view = view
        self.model = model
    }
}

extension HomePresenter: HomePresenterProtocol {
    var userProfile: UserProfile? {
        model.profile
    }
    
    var recentTracks: [TrackDetail] {
        model.recentTracks
    }
    
    var latestAlbums: [Album] {
        model.latestAlbums
    }
    
    func viewDidLoad() {
        model.delegate = self
        model.getRecentlyPlayedTracks()
        model.getNewReleases()
    }
}

extension HomePresenter: HomeModelDelegate {
    func didReceiveNewReleases() {
        view?.didReceiveNewReleases()
    }
    
    func didReceiveRecentTracks() {
        view?.didReceiveRecentTracks()
    }
}
