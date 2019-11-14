import Foundation
import Moya_ObjectMapper
import RxSwift

protocol ForecastWeatherRepository {
  func forecastWeather(requestData: ForecastWeatherRequest) -> Single<ForecastWeatherEntity>
}

final class ForecastWeatherRepositoryImpl: ForecastWeatherRepository {
  // MARK: - Properties
  let networkManager: Networkable
  
  // MARK: - Object Life Cycle
  init(networkManager: Networkable) {
    self.networkManager = networkManager
  }
  
  // MARK: - Public Methods
  func forecastWeather(requestData: ForecastWeatherRequest) -> Single<ForecastWeatherEntity> {
    return networkManager.request(target: WeatherTarget.forecastWeather(requestData))
      .mapObject(ForecastWeatherEntity.self)
      .asSingle()
  }
}
