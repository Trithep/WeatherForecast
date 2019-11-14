import Foundation

final class UseCaseProvider: UseCaseProtocol {
  
  // MARK: - Properties
  private let networkManager: Networkable
  
  // MARK: - Object Life Cycle
  init(networkManager: Networkable = NetworkManager(environment: .server)) {
    self.networkManager = networkManager
  }
  
  // MARK: - Internal Methods
  func makeSearchWeatherCityUseCase() -> SearchWeatherUseCase {
    let searchWeatherRepository = SearchWeatherRepositoryImpl(networkManager: networkManager)
    return SearchWeatherUseCaseImpl(searchWeatherRepository: searchWeatherRepository)
  }
}
