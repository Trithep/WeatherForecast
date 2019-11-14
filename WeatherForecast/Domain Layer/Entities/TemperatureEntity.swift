
import Foundation
import ObjectMapper

final class TemperatureEntity: Mappable {
  
  var temp: Double?
  var pressure: Int?
  var humidity: Int?
  var tempMin: Double?
  var tempMax: Double?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    temp          <- map["temp"]
    pressure      <- map["pressure"]
    humidity      <- map["humidity"]
    tempMin       <- map["temp_min"]
    tempMax       <- map["temp_max"]
  }
}

extension TemperatureEntity: Equatable {
  static func == (lhs: TemperatureEntity, rhs: TemperatureEntity) -> Bool {
    return lhs.temp == rhs.temp &&
      lhs.pressure == rhs.pressure &&
      lhs.humidity == rhs.humidity &&
      lhs.tempMin == rhs.tempMin &&
      lhs.tempMax == rhs.tempMax
  }
}
