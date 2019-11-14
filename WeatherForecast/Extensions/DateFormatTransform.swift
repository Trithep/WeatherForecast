import Foundation
import ObjectMapper

final class DateFormatTransform: TransformType {
  public typealias Object = Date
  public typealias JSON = String
  
  
  var dateFormat: DateFormatter
  
  init(dateFormat: String) {
    self.dateFormat = DateFormatter(withFormat: dateFormat, locale: "")
  }
  
  public func transformFromJSON(_ value: Any?) -> Object? {
    if let dateString = value as? String {
      return self.dateFormat.date(from: dateString)
    }
    return nil
  }
  public func transformToJSON(_ value: Date?) -> JSON? {
    if let date = value {
      return self.dateFormat.string(from: date )
    }
    return nil
  }
}
