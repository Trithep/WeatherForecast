import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

protocol SearchWeatherUseCase   {
  func execute(data: SearchWeatherRequest) -> Single<SearchWeatherEntity>
}

final class SearchWeatherUseCaseImpl: SearchWeatherUseCase   {
  // MARK: - Properties
  private let searchWeatherRepository: SearchWeatherRepository
  
  // MARK: - Object Life Cycle
  init(searchWeatherRepository: SearchWeatherRepository) {
    self.searchWeatherRepository = searchWeatherRepository
  }
  
  // MARK: - Internal Methods
  func execute(data: SearchWeatherRequest) -> Single<SearchWeatherEntity> {
    return searchWeatherRepository.searchWeather(requestData: data)
  }
}
