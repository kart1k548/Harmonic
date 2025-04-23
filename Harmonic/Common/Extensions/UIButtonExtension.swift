import UIKit

extension UIButton {
    func makeButton(with text: String = "", 
                    textColor: UIColor? = .silverGrey,
                    textFont: UIFont? = .gilroyMedium20,
                    width: CGFloat? = nil,
                    height: CGFloat? = nil,
                    cornerRadius: CGFloat? = nil,
                    bgColor: UIColor? = .clear) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = bgColor
        self.titleLabel?.font = textFont
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
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
    
    func makeButton(with icon: UIImage?, 
                    bgColor: UIColor = .clear,
                    width: CGFloat? = nil,
                    height: CGFloat? = nil,
                    cornerRadius: CGFloat? = nil,
                    tintColor: UIColor? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = tintColor
        self.backgroundColor = bgColor
        if let width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        self.setImage(icon, for: .normal)
    }
}
