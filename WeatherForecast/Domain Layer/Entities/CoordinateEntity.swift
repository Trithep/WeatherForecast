
import Foundation
import ObjectMapper

final class CoordinateEntity: Mappable {
  
  var long: Double?
  var lat: Double?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    long <- map["lon"]
    lat <- map["lat"]
  }
}

extension CoordinateEntity: Equatable {
  static func == (lhs: CoordinateEntity, rhs: CoordinateEntity) -> Bool {
    return lhs.long == rhs.long &&
      lhs.lat == rhs.lat 
  }
}
