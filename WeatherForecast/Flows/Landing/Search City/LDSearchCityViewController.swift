//
//  Created by Trithep Thumrongluck on 13/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities
import RxOptional

final class LDSearchCityViewController: BaseViewController {

  @IBOutlet private var searchTextField: UITextField!
  @IBOutlet private var searchButton: UIButton!
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var toggleStack: UIStackView!
  @IBOutlet private var celsiusButton: UIButton!
  @IBOutlet private var fahrenheitButton: UIButton!
  
  // MARK: Private variables
  private let services = UseCaseProvider(networkManager: NetworkManager(environment: .server))
  private lazy var viewModel: LDSearchCityType! = LDSearchCityViewModel(services: services)
  
  // MARK: Configure
  
  func configure(_ viewModel: LDSearchCityType) {
    self.viewModel = viewModel
  }
  
  // MARK: - View Life Cycle

  override func loadView() {
    super.loadView()
    bindInputs()
    bindOutputs()
  }
  
  override func setup() {
    super.setup()
    searchTextField.setLeftPaddingPoints(10)
    
    tableView.register(cellType: LDWeatherForecastList.self)
  }
  
  func bindInputs() {
    rx.viewDidLoad
      .mapTo(TemperatureType.celsius)
      .bind(to: viewModel.inputs.temperatureAction)
    .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .withLatestFrom(searchTextField.rx.text)
      .filterNil()
      .bind(to: viewModel.inputs.searchButtonAction)
      .disposed(by: disposeBag)
    
    celsiusButton.rx.tap
      .withLatestFrom(viewModel.outputs.currentTemperature)
      .filter { $0 != .celsius } /// Not repeating action on same type, if current temperatureType is celsius.
      .mapTo(TemperatureType.celsius)
      .bind(to: viewModel.inputs.temperatureAction)
      .disposed(by: disposeBag)
    
    fahrenheitButton.rx.tap
      .withLatestFrom(viewModel.outputs.currentTemperature)
      .filter { $0 != .fahrenheit } /// Not repeating action on same type, if current temperatureType is fahrenheit.
      .mapTo(TemperatureType.fahrenheit)
      .bind(to: viewModel.inputs.temperatureAction)
      .disposed(by: disposeBag)
  }
  
  func bindOutputs() {
    
    viewModel.outputs.isLoading
      .drive(navigationController?.view.rx.isProgressHUDVisible ?? view.rx.isProgressHUDVisible)
      .disposed(by: disposeBag)
    
    let _searchWeatherResult = viewModel.outputs.searchWeatherResult
    
    _searchWeatherResult
      .drive(tableView.rx.items){ (table, item, element) in
        let indexPath = IndexPath(item: item, section: 0)
        let cell: LDWeatherForecastList = table.dequeueReusableCell(for: indexPath) {
          $0.configure(element)
        }
        return cell
      }
      .disposed(by: disposeBag)
    
    _searchWeatherResult
      .asObservable()
      .map { $0.count == 0 }
      .bind(to: toggleStack.rx.isHidden)
      .disposed(by: disposeBag)
      
    viewModel.outputs.searchNotFound
      .asObservable()
      .flatMapLatest { [weak self] message -> Observable<RxAlertControllerResult> in
        guard let self = self else { return .never() }
        return UIAlertController.rx_presentAlert(
          viewController: self,
          title: "",
          message: message,
          actions: [ RxDefaultAlertAction(title: "OK", style: .default, result: .ok) ])
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    viewModel.outputs.currentTemperature
      .drive(onNext: { [weak self] stage in
        let isCelsius = (stage == .celsius)
        self?.celsiusButton.setTitleColor( isCelsius ? Color.white : Color.lightGrey, for: .normal)
        self?.celsiusButton.setBackgroundColor(isCelsius ? Color.orange : .clear, forState: .normal)
        
        self?.fahrenheitButton.setTitleColor(!isCelsius ? Color.white : Color.lightGrey, for: .normal)
        self?.fahrenheitButton.setBackgroundColor(!isCelsius ? Color.orange : .clear, forState: .normal)
      })
      .disposed(by: disposeBag)
  }
}

fileprivate extension UIButton {

  /// Sets the background color to use for the specified button state.
  func setBackgroundColor(_ color: UIColor, forState: UIControlState) {

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
