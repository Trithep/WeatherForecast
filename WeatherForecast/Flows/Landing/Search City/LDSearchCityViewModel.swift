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
  var isLoading: Driver<Bool> { get }
  var displayCityName: Driver<String> { get }
  var searchWeatherResult: Driver<[LDWeatherForecastListType]> { get }
  var searchNotFound: Driver<String> { get }
  var currentTemperature: Driver<TemperatureType> { get }
  var weatherForecastViewModel: LDWeatherForecastType? { get }
}

final class LDSearchCityViewModel: LDSearchCityType, LDSearchCityInputs, LDSearchCityOutputs {
  
  var inputs: LDSearchCityInputs { return self }
  var outputs: LDSearchCityOutputs { return self }
  
  // MARK: Inputs
  var searchButtonAction: PublishRelay<String> = .init()
  var temperatureAction: PublishRelay<TemperatureType> = .init()
  
  // MARK: Outputs
  var isLoading: Driver<Bool> { return _isLoading.asDriver() }
  var displayCityName: Driver<String> = .empty()
  var searchWeatherResult: Driver<[LDWeatherForecastListType]> = .empty()
  var searchNotFound: Driver<String> = .empty()
  var currentTemperature: Driver<TemperatureType> { return temperatureType.asDriver() }
  var weatherForecastViewModel: LDWeatherForecastType? {
    guard let weather = searchData.weather else { return nil }
    return LDWeatherForecastViewModel(services: services,
                                      cityName: weather.name ?? "",
                                      temperatureType: searchData.type)
  }
  
  // MARK: Private variables
  private var services: UseCaseProtocol
  private var disposeBag: DisposeBag
  private var temperatureType: BehaviorRelay<TemperatureType>
  private let _isLoading: ActivityIndicator
  private var searchData: (weather: SearchWeatherEntity?, type: TemperatureType)
  
  private lazy var searchWeatherUseCase: SearchWeatherUseCase = {
    services.makeSearchWeatherCityUseCase()
  }()
  
  // MARK: Init
  init(services: UseCaseProtocol) {
    self.services = services
    self.disposeBag = .init()
    self._isLoading = .init()
    self.temperatureType = .init(value: .fahrenheit)
    self.searchData = (nil, .fahrenheit)
    
    searchBinding(self.services, self._isLoading)
    toggleBinding()
  }
  
  // MARK: Private Functions
  private func searchBinding(_ services: UseCaseProtocol, _ isLoading: ActivityIndicator) {
    
    let searchResult = searchButtonAction /// Press search button then call API to get weather result.
      .withLatestFrom(temperatureType) { (name: $0, type: $1) } /// Making Tuple with city name and temperature type.
      .map { data in SearchWeatherRequest(name: data.name, unit: data.type) } /// Creating request data object.
      .flatMapLatest { requestData  in
        services.makeSearchWeatherCityUseCase() /// Calling API current weather by city name.
          .execute(data: requestData)
          .trackActivity(isLoading)
          .asObservable().materialize()
      }
      .filter { !$0.isCompleted }
      .share()
    
    displayCityName = searchResult
      .elements()
      .map { $0.name ?? "" }
      .asDriver(onErrorDriveWith: .empty())
    
    searchWeatherResult = searchResult
      .elements() /// Success  case, Binding result to display weather on view.
      .withLatestFrom(temperatureType) { (weather: $0, type: $1) }
      .do(onNext: { [unowned self] (data) in self.searchData = data })
      .map { LDWeatherForecastListViewModel(searchWeather: $0.weather, temperatureType: $0.type) }
      .map { [$0] }
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
  
  private func toggleBinding() {
    temperatureAction
      .bind(to: temperatureType)
      .disposed(by: disposeBag)
    
    temperatureAction
      .withLatestFrom(searchButtonAction)
      .bind(to: searchButtonAction)
      .disposed(by: disposeBag)
  }
  
}
