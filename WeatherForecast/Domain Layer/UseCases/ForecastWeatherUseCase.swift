import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

protocol ForecastWeatherUseCase   {
  func execute(data: ForecastWeatherRequest) -> Single<ForecastWeatherEntity>
}

final class ForecastWeatherUseCaseImpl: ForecastWeatherUseCase   {
  // MARK: - Properties
  private let forecastWeatherRepository: ForecastWeatherRepository
  
  // MARK: - Object Life Cycle
  init(forecastWeatherRepository: ForecastWeatherRepository) {
    self.forecastWeatherRepository = forecastWeatherRepository
  }
  
  // MARK: - Internal Methods
  func execute(data: ForecastWeatherRequest) -> Single<ForecastWeatherEntity> {
    return forecastWeatherRepository.forecastWeather(requestData: data)
  }
}
