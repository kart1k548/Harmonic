import UIKit

/// Singleton class responsible for handling image cache
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    /// Set an image for a given key in the image cache
    /// - parameter image: the image to add to the cache
    /// - parameter key: the related key
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    /// get an image from the image cache for a given key.
    /// - parameter key: the key to which the image should be related
    /// - returns: The image or nil if no image is found for that key
    func getImage(forKey key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
}
