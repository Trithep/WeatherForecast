
import UIKit

extension UIAlertController {
  
  static func okAlert(title: String, message: String, view: AnyObject, ok: (() -> ())?) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
      ok?()
    }
    alertController.addAction(OKAction)
    
    view.present(alertController, animated: true, completion: nil)
  }
  
  static func cancelAlert(title: String, message: String, view: AnyObject, callBack: @escaping(_ ok: Bool) -> ()) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) { (action: UIAlertAction!) in
      callBack(false)
    }
    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
      callBack(true)
    }
    alertController.addAction(OKAction)
    
    view.present(alertController, animated: true, completion: nil)
  }
  
  static func customAlert(title: String, message: String,
                          okTitle: String, cancelTitle: String,
                          view: AnyObject, callBack: @escaping(_ ok: Bool) -> ()) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action: UIAlertAction!) in
      callBack(false)
    }
    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: okTitle, style: .default) { (action: UIAlertAction!) in
      callBack(true)
    }
    alertController.addAction(OKAction)
    
    view.present(alertController, animated: true, completion: nil)
  }
}
