import UIKit

extension UIStackView {
    func makeStackView(axis: NSLayoutConstraint.Axis,
                       spacing: CGFloat = 0.0,
                       distribution: UIStackView.Distribution = .fill,
                       alignment: UIStackView.Alignment = .fill,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        if let width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func makeStackViewScrollable(scrollView: UIScrollView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    }
}
