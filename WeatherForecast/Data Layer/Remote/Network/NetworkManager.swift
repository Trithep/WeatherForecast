import Foundation
import Alamofire
import Moya
import RxSwift
import ObjectMapper

private class DefaultAlamofireManager: Alamofire.SessionManager {
  
  static let sharedManager: DefaultAlamofireManager = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 60
    configuration.timeoutIntervalForResource = 300
    configuration.requestCachePolicy = .useProtocolCachePolicy
    
    return DefaultAlamofireManager(configuration: configuration)
  }()
}

enum AppError: Error {
  case service(ErrorEntity)
  case unknown
}

class NetworkManager: Networkable {
  
  static var defaultMessage: String = "The request was not completed."
  
  // MARK: - Typealias or Enum
  enum Environment {
    case local
    case server
    
    func stubClosure(for target: TargetType) -> Moya.StubBehavior {
      return (self == .server ? .never : .immediate)
    }
  }
  
  // MARK: - Properties
  private var serverTrustPolicy: ServerTrustPolicy?
  private var serverTrustPolicies: [String: ServerTrustPolicy]?
  private var environment: Environment
  private lazy var plugins: [PluginType] = {
    return [ NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter) ]
  }()
  
  // MARK: - Object Life Cycle
  init(environment: Environment = .server) {
    self.environment = environment
  }
  
  // MARK: - Internal Methods
  private func mockJsonResponse(name: String) -> [String: Any]? {
    if let path = Bundle.main.path(forResource: name, ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as? [String: Any]
      } catch {
        return nil
      }
    }
    return nil
  }
  
  func request<Target: TargetType>(target: Target) -> Observable<Moya.Response> {
    let provider = MoyaProvider<Target>(stubClosure: environment.stubClosure,
                                        manager: DefaultAlamofireManager.sharedManager,
                                        plugins: plugins)
    
    var createRequest: Observable<Response> {
      return Observable.create { (observer) -> Disposable in
        let request: Cancellable
        let progressBlock: ProgressBlock
        let completionBlock: Completion
        
        progressBlock = { (progress) in }
        
        completionBlock = { result in
          switch result {
          case let .success(response):
            observer.onNext(response)
            observer.onCompleted()
          case let .failure(moyaError):
            guard case let .underlying(_, response) = moyaError, let _response = response else {
              return observer.onError(AppError.unknown)
            }
            
            let error: ErrorEntity = .init(code: _response.statusCode, message: _response.description)
            observer.onError(AppError.service(error))
          }
        }
        
        request = provider.request(target,
                                   callbackQueue: DispatchQueue.global(qos: .utility),
                                   progress: progressBlock,
                                   completion: completionBlock)
        
        return Disposables.create { request.cancel() }
      }
    }
    
    return createRequest
  }
  
  // MARK: - Private Methods
  private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: data)
      let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return prettyData
    } catch {
      return data
    }
  }
}

extension Error {
  var apiError: AppError {
    return self as! AppError
  }
}
