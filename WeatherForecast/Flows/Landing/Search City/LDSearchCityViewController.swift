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
    searchButton.rx.tap
      .withLatestFrom(searchTextField.rx.text)
      .filterNil()
      .bind(to: viewModel.inputs.searchButtonAction)
      .disposed(by: disposeBag)
  }
  
  func bindOutputs() {
    
    (viewModel.outputs.searchWeatherResult)
      .drive(tableView.rx.items){ (table, item, element) in
      let indexPath = IndexPath(item: item, section: 0)
       
      let cell: LDWeatherForecastList = table.dequeueReusableCell(for: indexPath) {
        $0.configure(element)
      }

      return cell
    }
    .disposed(by: disposeBag)
      
    
    
    viewModel.outputs.searchNotFound
      .asObservable()
      .flatMapLatest { [weak self] message -> Observable<RxAlertControllerResult> in
        guard let self = self else { return .never() }
        
        return UIAlertController.rx_presentAlert(
          viewController: self,
          title: "",
          message: message,
          actions: [
            RxDefaultAlertAction(title: "OK", style: .default, result: .ok)
          ])
      }
      .subscribe()
      .disposed(by: disposeBag)
    
  }
  
}
