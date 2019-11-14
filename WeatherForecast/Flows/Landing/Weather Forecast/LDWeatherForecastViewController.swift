//
//  Created by Trithep Thumrongluck on 13/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities
import RxOptional

final class LDWeatherForecastViewController: LandingBaseViewController {

  // MARK: IBOutlets
  @IBOutlet private var tableView: UITableView!
  
  // MARK: Private variables
  private var viewModel: LDWeatherForecastType!
  
  // MARK: Configure
  func configure(_ viewModel: LDWeatherForecastType) {
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
    tableView.register(cellType: LDWeatherForecastList.self)
  }
  
  func bindInputs() {
    rx.viewDidAppear
      .bind(to: viewModel.inputs.onViewDidAppear)
      .disposed(by: disposeBag)
  }
  
  func bindOutputs() {
    viewModel.outputs.weatherForecastResult
    .drive(tableView.rx.items){ (table, item, element) in
      let indexPath = IndexPath(item: item, section: 0)
      let cell: LDWeatherForecastList = table.dequeueReusableCell(for: indexPath) {
        $0.configure(element)
      }
      return cell
    }
    .disposed(by: disposeBag)
  }
}
