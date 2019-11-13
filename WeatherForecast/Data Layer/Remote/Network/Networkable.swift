import Foundation
import Moya
import RxSwift

protocol Networkable {
  func request<Target: TargetType>(target: Target) -> Observable<Moya.Response>
}
