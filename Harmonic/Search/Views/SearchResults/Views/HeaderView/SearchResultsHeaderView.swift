import Foundation
import UIKit

class SearchResultsHeaderView: UITableViewHeaderFooterView {
    static let identifier = "SearchResultsHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.makeLabel(textFont: .nunitoSemiBold22)
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        add(view: titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
