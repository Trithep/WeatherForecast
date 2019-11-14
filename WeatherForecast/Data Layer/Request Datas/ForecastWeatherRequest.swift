//
//  Created by Trithep Thumrongluck on 12/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//
import ObjectMapper

final class ForecastWeatherRequest: Mappable {
  // MARK: - Properties
  var name: String?
  var unit: String?
  var limit: Int?
  var appId: String?
  
  init(name: String, unit: TemperatureType, limit: Int) {
    self.name = name
    self.unit = unit.rawValue
    self.limit = limit
    self.appId = AppConfig.appId
  }
  
  required init?(map: Map) {
    if map.JSON["appid"] == nil {
      return nil
    }
  }
  
  // MARK: - Internal Methods
  func mapping(map: Map) {
    name  <- map["q"]
    unit  <- map["units"]
    limit <- map["cnt"]
    appId <- map["appid"]
  }
}
