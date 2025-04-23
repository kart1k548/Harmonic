import UIKit

extension UIColor {
    static let bgColor = UIColor(named: "bgColor")
    static let darkBgColor = UIColor(named: "darkBgColor")
    static let lightestGrey = UIColor(named: "silverGrey")
    static let lightestBlue = UIColor(named: "lightestBlue")
    static let lightestPurple = UIColor(named: "lightPurple")
    
    static func getCategoryColor() -> UIColor? {
        let colors: [UIColor] = [
            .systemPink,
            .systemBlue,
            .systemPurple,
            .systemOrange,
            .systemGreen,
            .systemRed,
            .systemBrown,
            .systemCyan,
            .systemTeal
        ]
        
        return colors.randomElement()
    }
}
