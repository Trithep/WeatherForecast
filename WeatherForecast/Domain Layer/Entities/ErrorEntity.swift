import Foundation
import ObjectMapper

final class ErrorEntity: Mappable {
  // MARK: - Properties
  var code: Int?
  var message: String?
  
  // MARK: - Object Life Cycle
  init(code: Int, message: String) {
    self.message = message
    self.code = code
  }
  
  init() {
    
  }
  
  required public init?(map: Map) {
    
  }
  
  // MARK: - Internal Methods
  func mapping(map: Map) {
    code              <- map["code"]
    message           <- map["message"]
  }
  
}

extension ErrorEntity: Equatable {
  static func == (lhs: ErrorEntity, rhs: ErrorEntity) -> Bool {
    return lhs.code == rhs.code &&
      lhs.message == rhs.message
  }
}
