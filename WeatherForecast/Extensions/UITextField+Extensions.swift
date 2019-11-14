
import UIKit

extension UITextField {
  
  func setLeftPaddingPoints(_ amount: CGFloat) {
    
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    leftViewMode = .always
  }
}
