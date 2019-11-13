//
//  Created by Trithep Thumrongluck on 12/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//

import Moya

enum WeatherTarget {
  case currentWeather(WeatherRequest)
  case forecastWeather(WeatherRequest)
}

extension WeatherTarget: TargetType {
  var baseURL: URL {
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/")
      else { fatalError("Invalid URL") }
    return url
  }
  
  var path: String {
    switch self {
    case .currentWeather:
      return "weather"
    case .forecastWeather:
      return "forecast"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .currentWeather, .forecastWeather:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case let .currentWeather(requestData):
      return .requestParameters(parameters: requestData.toJSON(), encoding: JSONEncoding.default)
    case let .forecastWeather(requestData):
      return .requestParameters(parameters: requestData.toJSON(), encoding: JSONEncoding.default)
    }
  }
  
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
  var headers: [String: String]? {
    return nil
  }
}
