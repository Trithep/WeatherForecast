import Foundation
import ObjectMapper

final class ErrorEntity: Mappable {
  // MARK: - Properties
  var code: String?
  var message: String?
  
  // MARK: - Object Life Cycle
  init(code: String, message: String) {
    self.code = code
    self.message = message
  }
  
  required public init?(map: Map) {
    
  }
  
  // MARK: - Internal Methods
  func mapping(map: Map) {
    code              <- map["cod"]
    message           <- map["message"]
  }
  
}

extension ErrorEntity: Equatable {
  static func == (lhs: ErrorEntity, rhs: ErrorEntity) -> Bool {
    return lhs.code == rhs.code &&
      lhs.message == rhs.message
  }
}
