import UIKit

extension UILabel {
    func makeLabel(with text: String = "Label", 
                   alignment: NSTextAlignment = .left,
                   textColor: UIColor = .silverGrey,
                   textFont: UIFont? = .gilroyMedium20,
                   bgColor: UIColor = .clear) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.font = textFont
        self.textAlignment = alignment
        self.textColor = textColor
        self.backgroundColor = bgColor
    }
}
