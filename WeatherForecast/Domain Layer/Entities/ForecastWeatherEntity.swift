import Foundation
import ObjectMapper

final class ForecastWeatherEntity: Mappable {
  // MARK: - Properties
  var list: [SearchWeatherEntity]?
  
  required init?(map: Map) {
  
  }
  
  func mapping(map: Map) {
    list  <- map["list"]
  }
}
