import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
    func add(view: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: left),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: right),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: top),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom)
        ])
    }
    
    func makeSpacerView(height: CGFloat) {
        self.frame = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).setActiveBreakable()
    }
    
    func makeSpacerView(width: CGFloat) {
        self.frame = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).setActiveBreakable()
    }
}

extension UITableViewCell {
    func addToContentView(view: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: left),
            view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: right),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: top),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: bottom)
        ])
    }
}

extension UICollectionViewCell {
    func addToContentView(view: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: left),
            view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: right),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: top),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: bottom)
        ])
    }
}
