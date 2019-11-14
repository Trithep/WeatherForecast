//
//  Created by Trithep Thumrongluck on 13/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//
import RxSwift
import RxSwiftExt
import RxCocoa
import RxSwiftUtilities
import RxOptional

protocol LDWeatherForecastType {
  var inputs: LDWeatherForecastInputs { get }
  var outputs: LDWeatherForecastOutputs { get }
}

protocol LDWeatherForecastInputs {
  var onViewDidAppear: PublishRelay<Void> { get }
}

protocol LDWeatherForecastOutputs {
  var isLoading: Driver<Bool> { get }
  var weatherForecastResult: Driver<[LDWeatherForecastListType]> { get }
}

final class LDWeatherForecastViewModel: LDWeatherForecastType, LDWeatherForecastInputs, LDWeatherForecastOutputs {
  
  var inputs: LDWeatherForecastInputs { return self }
  var outputs: LDWeatherForecastOutputs { return self }
  
  // MARK: Inputs
  var onViewDidAppear: PublishRelay<Void> = .init()
  
  // MARK: Outputs
  var isLoading: Driver<Bool> { return _isLoading.asDriver() }
  var weatherForecastResult: Driver<[LDWeatherForecastListType]> = .empty()
  
  // MARK: Private variables
  private var services: UseCaseProtocol
  private var disposeBag: DisposeBag
  private var weatherData: BehaviorRelay<(name: String, type: TemperatureType)>
  private let _isLoading: ActivityIndicator
  
  private lazy var forecastWeatherUseCase: ForecastWeatherUseCase = {
    services.makeWeatherForecastUseCase()
  }()
  
  // MARK: Init
  init(services: UseCaseProtocol, cityName: String, temperatureType: TemperatureType) {
    self.services = services
    self.disposeBag = .init()
    self._isLoading = .init()
    self.weatherData = .init(value: (cityName, temperatureType))
    
    forecasthBinding(self.services, self._isLoading)
  }
  
  // MARK: Private Functions
  private func forecasthBinding(_ services: UseCaseProtocol, _ isLoading: ActivityIndicator) {
    
    let forecastResult = onViewDidAppear
      .withLatestFrom(weatherData)
      .map { data in ForecastWeatherRequest(name: data.name, unit: data.type, limit: 5) }
      .flatMapLatest {
        services.makeWeatherForecastUseCase().execute(data: $0)
          .asObservable().trackActivity(isLoading)
          .materialize()
      }
      .filter { !$0.isCompleted }
      .share()
    
    weatherForecastResult = forecastResult.elements()
      .withLatestFrom(weatherData) { (result: $0, type: $1) }
      .map { data -> [LDWeatherForecastListType]? in
        return data.result.list?.compactMap { LDWeatherForecastListViewModel(searchWeather: $0, temperatureType: .celsius) }
      }
      .filterNil()
      .asDriver(onErrorDriveWith: .empty())
  }
  
}
