import Foundation
import ObjectMapper

final class SearchWeatherEntity: Mappable {
  // MARK: - Properties
  var coordinate: CoordinateEntity?
  var weathers: [WeatherEntity]?
  var temperature: TemperatureEntity?
  var date: Date?
  
  required init?(map: Map) {
  
  }
  
  func mapping(map: Map) {
    coordinate    <- map["coord"]
    weathers      <- map["weather"]
    temperature   <- map["main"]
    date          <- (map["dt_txt"], DateFormatTransform(dateFormat: "yyyy-MM-dd"))
  }
}


