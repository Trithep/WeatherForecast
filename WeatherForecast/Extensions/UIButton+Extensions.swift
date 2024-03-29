import UIKit

extension UIButton {

  /// Sets the background color to use for the specified button state.
  func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {

    let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)

    UIGraphicsBeginImageContext(minimumSize)

    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(origin: .zero, size: minimumSize))
    }

    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    clipsToBounds = true
    setBackgroundImage(colorImage, for: forState)
  }
}
