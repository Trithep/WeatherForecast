//
//  Created by Trithep Thumrongluck on 13/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//
import RxSwift
import RxSwiftExt
import RxCocoa
import RxSwiftUtilities
import RxOptional

protocol LDSearchCityType {
  var inputs: LDSearchCityInputs { get }
  var outputs: LDSearchCityOutputs { get }
}

protocol LDSearchCityInputs {
  var searchButtonAction: PublishRelay<String> { get }
  var temperatureAction: PublishRelay<TemperatureType> { get }
}

protocol LDSearchCityOutputs {
  var searchWeatherResult: Driver<[LDWeatherForecastListType]> { get }
  var searchNotFound: Driver<String> { get }
}

enum TemperatureType: String {
  case celsius = "metric"
  case fahrenheit = "imperial"
}

final class LDSearchCityViewModel: LDSearchCityType, LDSearchCityInputs, LDSearchCityOutputs {
  
  var inputs: LDSearchCityInputs { return self }
  var outputs: LDSearchCityOutputs { return self }
  
  // MARK: Inputs
  var searchButtonAction: PublishRelay<String> = .init()
  var temperatureAction: PublishRelay<TemperatureType> = .init()
  
  // MARK: Outputs
  var searchWeatherResult: Driver<[LDWeatherForecastListType]> = .empty()
  var searchNotFound: Driver<String> = .empty()
  
  // MARK: Private variables
  private var services: UseCaseProtocol
  private var disposeBag: DisposeBag
  private var temperatureType: BehaviorRelay<TemperatureType>
  
  private lazy var searchWeatherUseCase: SearchWeatherUseCase = {
    services.makeSearchWeatherCityUseCase()
  }()
  
  init(services: UseCaseProtocol) {
    self.services = services
    self.disposeBag = .init()
    self.temperatureType = .init(value: .fahrenheit)
    
    bind()
  }
  
  private func bind() {
    
    let searchResult = searchButtonAction /// Press search button then call API to get weather result.
      .withLatestFrom(temperatureType) { (name: $0, type: $1) } /// Making Tuple with city name and temperature type.
      .map { data in SearchWeatherRequest(name: data.name, unit: data.type) } /// Creating request data object.
      .flatMapLatest { [unowned self] requestData  in
        self.services.makeSearchWeatherCityUseCase() /// Calling API current weather by city name.
          .execute(data: requestData)
          .asObservable().materialize()
      }
      .filter { !$0.isCompleted }
      .share()
    
    searchWeatherResult = searchResult
      .elements() /// Success  case, Binding result to display weather on view.
      .map { [LDWeatherForecastListViewModel(searchWeather: $0)] }
      .asDriver(onErrorDriveWith: .empty())
    
    searchNotFound = searchResult
      .errors() /// Failure  case, Binding result to display alert message on view.
      .map {
        switch $0.apiError {
        case let .service(error):
          return error.message ?? NetworkManager.defaultMessage
        case .unknown:
          return NetworkManager.defaultMessage
        }
      }
      .asDriver(onErrorDriveWith: .empty())
    
  }
  
}
