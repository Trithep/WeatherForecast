
import Foundation

protocol LDWeatherForecastListType {
  var inputs: LDWeatherForecastListInputs { get }
  var outputs: LDWeatherForecastListOutputs { get }
}

protocol LDWeatherForecastListInputs {
  
}

protocol LDWeatherForecastListOutputs {
  var weatherDay: String { get }
  var iconImg: String { get }
  var temperature: String { get }
  var humidity: String { get }
}

final class LDWeatherForecastListViewModel: LDWeatherForecastListType, LDWeatherForecastListInputs, LDWeatherForecastListOutputs {
  
  var inputs: LDWeatherForecastListInputs { return self }
  var outputs: LDWeatherForecastListOutputs { return self }
  
  // MARK: Outputs
  var weatherDay: String { return makeWeatherDate(searchWeather) }
  var iconImg: String { return "\(searchWeather.weathers?.first?.icon ?? "-").png" }
  var temperature: String { return "\(searchWeather.temperature?.temp ?? 0) \(makeTemperatureUnit(temperatureType))" }
  var humidity: String { return "\(searchWeather.temperature?.humidity ?? 0)" }
  
  // MARK: Private variables
  private var searchWeather: SearchWeatherEntity
  private var temperatureType: TemperatureType
  
  init(searchWeather: SearchWeatherEntity, temperatureType: TemperatureType) {
    self.searchWeather = searchWeather
    self.temperatureType = temperatureType
  }
  
  private func makeWeatherDate(_ searchWeather: SearchWeatherEntity) -> String {
    let _date = searchWeather.date ?? Date()
    return DateFormatter().shortFormat.string(from: _date)
  }
  
  private func makeTemperatureUnit(_ temperatureType: TemperatureType) -> String {
    return temperatureType == .celsius ? "°C" : "°F"
  }
  
}

fileprivate extension DateFormatter {
  
  var shortFormat: DateFormatter {
    locale = Locale(identifier: "en_US")
    timeZone = TimeZone(identifier: "Asia/Bangkok")
    calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    dateFormat = "d MMM yy"
    return self
  }
  
}

