import Foundation
import Moya_ObjectMapper
import RxSwift

protocol SearchWeatherRepository {
  func searchWeather(requestData: SearchWeatherRequest) -> Single<SearchWeatherEntity>
}

final class SearchWeatherRepositoryImpl: SearchWeatherRepository {
  // MARK: - Properties
  let networkManager: Networkable
  
  // MARK: - Object Life Cycle
  init(networkManager: Networkable) {
    self.networkManager = networkManager
  }
  
  // MARK: - Public Methods
  func searchWeather(requestData: SearchWeatherRequest) -> Single<SearchWeatherEntity> {
    return networkManager.request(target: WeatherTarget.searchWeather(requestData))
      .mapObject(SearchWeatherEntity.self)
      .asSingle()
  }
}
