import Foundation

protocol UseCaseProtocol {
  func makeSearchWeatherCityUseCase() -> SearchWeatherUseCase
  func makeWeatherForecastUseCase() -> ForecastWeatherUseCase
}
