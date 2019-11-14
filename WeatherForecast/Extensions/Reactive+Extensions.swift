import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa
import RxSwiftUtilities

// MARK: - Loading
extension Reactive where Base: UIView {
  var isProgressHUDVisible: Binder<Bool> {
    return Binder(self.base) { _, active in
      if active {
        guard MBProgressHUD(for: self.base) == nil else { return }
        let progressHUD = MBProgressHUD.showAdded(to: self.base, animated: true)
        progressHUD.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        progressHUD.backgroundView.color = UIColor(white: 0.0, alpha: 0.0)
      } else {
        MBProgressHUD.hide(for: self.base, animated: false)
      }
    }
  }
}

// MARK: - ViewController Event
extension Reactive where Base: UIViewController {
  var touchesBegan: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.touchesBegan(_:with:)))
  }
  
  var touchesEnded: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.touchesEnded(_:with:)))
  }
  
  var viewDidLoad: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewDidLoad))
  }
  
  var viewWillAppear: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewWillAppear(_:)))
  }
  
  var viewDidAppear: ControlEvent<Void> {
    return controlEvent(selector: #selector(Base.viewDidAppear(_:)))
  }
  
  func controlEvent(selector: Selector) -> ControlEvent<Void> {
    let source = methodInvoked(selector).map { (_) in () }
    return ControlEvent(events: source)
  }
}

