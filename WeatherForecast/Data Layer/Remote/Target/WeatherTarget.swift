//
//  Created by Trithep Thumrongluck on 12/11/2562 BE.
//  Copyright © 2562 Trithep Thumrongluck. All rights reserved.
//

import Moya

enum WeatherTarget {
  case searchWeather(SearchWeatherRequest)
  case forecastWeather(ForecastWeatherRequest)
}

extension WeatherTarget: TargetType {
  var baseURL: URL {
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/")
      else { fatalError("Invalid URL") }
    return url
  }
  
  var path: String {
    switch self {
    case .searchWeather:
      return "weather"
    case .forecastWeather:
      return "forecast"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .searchWeather, .forecastWeather:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case let .searchWeather(requestData):
      return .requestParameters(parameters: requestData.toJSON(), encoding: URLEncoding.default)
    case let .forecastWeather(requestData):
      return .requestParameters(parameters: requestData.toJSON(), encoding: URLEncoding.default)
    }
  }
  
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
  var headers: [String: String]? {
    return nil
  }
}
