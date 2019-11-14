
import Foundation
import ObjectMapper

final class WeatherEntity: Mappable {
  
  var id: Int?
  var main: String?
  var description: String?
  var icon: String?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    id          <- map["id"]
    main        <- map["main"]
    description <- map["description"]
    icon        <- map["icon"]
  }
}

extension WeatherEntity: Equatable {
  static func == (lhs: WeatherEntity, rhs: WeatherEntity) -> Bool {
    return lhs.id == rhs.id &&
      lhs.main == rhs.main &&
      lhs.description == rhs.description &&
      lhs.icon == rhs.icon
  }
}
