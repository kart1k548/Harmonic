import UIKit

protocol URLOpener {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?)
}

extension URLOpener {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: (@MainActor @Sendable (Bool) -> Void)? = nil) {
        return open(url, options: options, completionHandler: completion)
    }
}

extension UIApplication: URLOpener {}
