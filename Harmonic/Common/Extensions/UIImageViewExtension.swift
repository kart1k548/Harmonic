import UIKit

extension UIImageView {
    /// Loads the image from cache, if not found in cache then loads it after downloading
    /// - Parameter urlString: String URL of the image resource
    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        self.image = nil
        if let cacheImage = ImageCache.shared.getImage(forKey: urlString) {
            self.image = cacheImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print(error)
            }
            
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = downloadedImage
                    ImageCache.shared.set(downloadedImage, forKey: urlString)
                }
            }
        }.resume()
    }
    
    func makeImageView(image: UIImage? = nil,
                       bgColor: UIColor = .clear,
                       tintColor: UIColor? = nil,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil,
                       cornerRadius: CGFloat? = nil,
                       clipsToBounds: Bool = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        self.backgroundColor = bgColor
        self.tintColor = tintColor
        self.clipsToBounds = clipsToBounds
        if let width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
