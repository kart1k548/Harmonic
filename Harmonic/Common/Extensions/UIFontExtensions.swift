import UIKit

enum FontWeight {
    case regular
    case semibold
    case extrabold
}

extension UIFont {
    static let gilroyMedium20 = UIFont(name: "Gilroy-Medium", size: 20)
    static let gilroyMedium18 = UIFont(name: "Gilroy-Medium", size: 18)
    static let gilroyMedium14 = UIFont(name: "Gilroy-Medium", size: 14)
    static let gilroyRegular14 = UIFont(name: "Gilroy-Regular", size: 14)
    static let gilroyRegular18 = UIFont(name: "Gilroy-Regular", size: 18)
    static let gilroyBold24 = UIFont(name: "Gilroy-Bold", size: 24)
    static let gilroyBold22 = UIFont(name: "Gilroy-Bold", size: 22)
    static let gilroyHeavy22 = UIFont(name: "Gilroy-Heavy", size: 22)
    static let nunitoSemiBold22 = UIFont(name: "Nunito-SemiBold", size: 22)
    static let nunitoSemiBold18 = UIFont(name: "Nunito-SemiBold", size: 18)
    static let nunitoRegular22 = UIFont(name: "Nunito-Regular", size: 24)
    static let nunitoRegular14 = UIFont(name: "Nunito-Regular", size: 14)
    static let nunitoRegular16 = UIFont(name: "Nunito-Regular", size: 16)
    static let nunitoRegular18 = UIFont(name: "Nunito-Regular", size: 18)
    
    static func getCustomSizedFont(fontWeight: FontWeight, size: CGFloat) -> UIFont? {
        switch fontWeight {
        case .regular: return UIFont(name: "Nunito-Regular", size: size)
        case .semibold: return UIFont(name: "Nunito-SemiBold", size: size)
        case .extrabold: return UIFont(name: "Nunito-ExtraBold", size: size)
        }
    }
}
