import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class LDWeatherForecastList: BaseList {
  
  @IBOutlet private var dateLabel: UILabel!
  @IBOutlet private var weatherImageView: UIImageView!
  @IBOutlet private var tempLabel: UILabel!
  @IBOutlet private var humidityLabel: UILabel!
  
  // MARK: - Properties
  private var viewModel: LDWeatherForecastListType!
  
  // MARK: - Configure
  func configure(_ viewModel: LDWeatherForecastListType) {
    self.viewModel = viewModel
    bindInputs()
    bindOutputs()
  }

}

extension LDWeatherForecastList {
  
  func bindInputs() {
    
  }
  
  func bindOutputs() {
    dateLabel.text = viewModel.outputs.weatherDay
    tempLabel.text = viewModel.outputs.temperature
    humidityLabel.text = viewModel.outputs.humidity
    weatherImageView.image = UIImage(named: viewModel.outputs.iconImg)
  }
}
