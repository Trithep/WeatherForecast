import UIKit

struct Font {
  enum DBAdmanRoundedStyle {
    case boldItalic
    case bold
    case italic
    case regular
  }
  
  static func dbAdmanRounded(ofSize fontSize: CGFloat, fontStyle: DBAdmanRoundedStyle) -> UIFont {
    switch fontStyle {
    case .boldItalic: return UIFont(name: "DBAdmanRoundedX-BoldItalic", size: fontSize)!
    case .bold: return UIFont(name: "DBAdmanRoundedX-Bold", size: fontSize)!
    case .italic: return UIFont(name: "DBAdmanRoundedX-Italic", size: fontSize)!
    case .regular: return UIFont(name: "DBAdmanRoundedX", size: fontSize)!
    }
  }
}

enum Color {
  static let lightGrey = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 0.5036861796)
  static let grey = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
  static let orange = #colorLiteral(red: 0.8985010386, green: 0.4999262094, blue: 0.3142812848, alpha: 1)
  static let white = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}
