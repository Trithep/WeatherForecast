import UIKit
import Reusable
import RxSwift

class BaseList: UITableViewCell, NibReusable {
  // MARK: - Properties
  private(set) var disposeBag = DisposeBag()
  
  // MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    addObserver()
    setup()
    setupLayout()
  }
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
    super.prepareForReuse()
  }
  
  override func layoutIfNeeded() {
    super.layoutIfNeeded()
    setupLayout()
  }
  
  deinit {
    self.removeObserver()
  }
  
  // MARK: - Setup
  func setup() {
    
  }
  
  // MARK: - SetupLayout
  func setupLayout() {
    
  }
  
  // MARK: - Internal Methods
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with:event)
    self.endEditing(true)
  }
  
  func addObserver() {
  }
  
  func removeObserver() {
  }
}
