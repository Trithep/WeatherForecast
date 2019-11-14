
import UIKit

final class IBButton: UIButton {
  
  @IBInspectable var shadowColor: UIColor = UIColor.clear {
    didSet {
      layer.shadowColor = shadowColor.cgColor
    }
  }
  
  @IBInspectable var shadowOpacity: Float = 0 {
    didSet {
      layer.shadowOpacity = shadowOpacity
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat = 0 {
    didSet {
      layer.shadowRadius = shadowRadius
    }
  }
  
  @IBInspectable var shadowOffset: CGSize = CGSize.zero {
    didSet {
      layer.shadowOffset = shadowOffset
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable var borderColor: UIColor = UIColor.clear {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  func setShadow(_ color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowRadius = radius
    layer.shadowOffset = offset
  }
  
  //MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
    self.initialize()
  }
  
  func initialize() {
    
  }
}
