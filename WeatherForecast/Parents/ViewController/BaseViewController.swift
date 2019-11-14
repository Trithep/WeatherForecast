import UIKit
import RxSwift

class BaseViewController: UIViewController {
  
  // MARK: - Layout Properties
  override var preferredStatusBarStyle: UIStatusBarStyle {
    if #available(iOS 13.0, *) {
      return .darkContent
    } else {
      return .default
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return false
  }
  
  // MARK: - Properties
  var disposeBag = DisposeBag()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addObservers()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let navigationController = navigationController {
      setupNavigationController(navigationController: navigationController, animated: animated)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupLayout()
  }
  
  deinit {
    removeObservers()
  }
  
  // MARK: - Setup
  func setup() {
    if #available(iOS 13.0, *) {
        // Always adopt a light interface style.
        overrideUserInterfaceStyle = .light
    }
  }
  
  // MARK: - SetupLayout
  func setupLayout() {
    
  }
  
  func setupNavigationController(navigationController: UINavigationController, animated: Bool) {

    /// Set transparent of navigationBar
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.isTranslucent = false
    navigationController.view.backgroundColor = .white
    /// Set light mode
    if #available(iOS 13.0, *) {
      let navBarAppearance = UINavigationBarAppearance()
      navBarAppearance.configureWithOpaqueBackground()
      navBarAppearance.titleTextAttributes = [.foregroundColor: Color.grey,
                                              .font: Font.dbAdmanRounded(ofSize: 24, fontStyle: .bold)]
      navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Color.grey]
      navBarAppearance.backgroundColor = .white
      navigationController.navigationBar.standardAppearance = navBarAppearance
      navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    /// Set title naviagtionBar
    let attributes: [NSAttributedString.Key : Any] = [
      .font: Font.dbAdmanRounded(ofSize: 24.0, fontStyle: .bold),
      .foregroundColor: Color.grey
    ]
    navigationController.navigationBar.titleTextAttributes = attributes

    /// Set navigation bar color
    navigationController.navigationBar.tintColor = .white
  }
  
  // MARK: - Internal Methods
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with:event)
    view.endEditing(true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segue.destination.modalPresentationStyle = .fullScreen
  }
  
  func addObservers() {
    
  }
  
  func removeObservers() {
    
  }
}
