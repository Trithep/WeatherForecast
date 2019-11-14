import UIKit
import Reusable

extension UITableView {
  func dequeueReusableCell<T>(for indexPath: IndexPath, execute: ((T) -> ())? = nil) -> T where T: BaseList {
    let cell: T = dequeueReusableCell(for: indexPath)
    execute?(cell)
    return cell
  }
  
  func scrollToBottom() {
    guard let tableFooterView = self.tableFooterView else { return }
    self.scrollRectToVisible(self.convert(tableFooterView.bounds, from: tableFooterView), animated: true)
  }
}
