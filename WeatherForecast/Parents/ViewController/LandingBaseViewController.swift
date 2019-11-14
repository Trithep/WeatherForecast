import UIKit

class LandingBaseViewController: BaseViewController {
  // MARK: - Object Life Cycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
  }
  
  override func setupNavigationController(navigationController: UINavigationController, animated: Bool) {
    super.setupNavigationController(navigationController: navigationController, animated: animated)
    guard navigationController.children.count > 1 else { return }
    let backButton = UIButton()
    let backButtonImage = UIImage(named: "ic_back")
    backButton.setImage(backButtonImage, for: .normal)
    backButton.sizeToFit()
    backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    
    let barButtonItem = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = barButtonItem
  }
  
  @objc private func backButtonAction() {
    navigationController?.popViewController(animated: true)
  }
}
