//
//  Networking.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import UIKit
import Foundation
import SystemConfiguration

import ObjectMapper
import Moya
import RxSwift
import RxCocoa


let nonErrorMessage: String = "알 수 없는 에러 발생"

protocol NetworkingProtocol {
    func request(_ target: TargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension NetworkingProtocol {
    func request(_ target: TargetType, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
        return self.request(target, file: file, function: function, line: line)
    }
}

final class Networking: MoyaProvider<MultiTarget>, NetworkingProtocol {

    var disposeBag: DisposeBag = DisposeBag()

    let intercepter: ConnectChecker

    init(logger: [PluginType]) {
        let intercepter = ConnectChecker()
        self.intercepter = intercepter
        let session = MoyaProvider<MultiTarget>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        super.init(requestClosure: { endPoint, completion in
            do {
                let urlRequest = try endPoint.urlRequest()
                intercepter.adapt(urlRequest, for: session, completion: completion)
            } catch MoyaError.requestMapping(let url) {
                completion(.failure(MoyaError.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                completion(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                completion(.failure(MoyaError.underlying(error, nil)))
            }

        }, session: session, plugins: logger)
    }

    func request(_ target: TargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return self.rx.request(.target(target))
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { value in
                let message = "SUCCESS: \(requestString) (\(value.statusCode)"
                log.debug(message, file: file, function: function, line: line)
            }, onError: { error in
                if let response = (error as? MoyaError)?.response {
                    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                        log.warning(message, file: file, function: function, line: line)
                    } else if let rawString = String(data: response.data, encoding: .utf8) {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                        log.warning(message, file: file, function: function, line: line)
                    } else {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))"
                        log.warning(message, file: file, function: function, line: line)
                    }
                } else {
                    let message = "FAILURE: \(requestString)\n\(error)"
                    log.debug(message, file: file, function: function, line: line)
                }

            }, onSubscribed: {
                let message = "REQUEST: \(requestString)"
                log.debug(message)
            })
            .catchError { result in
                guard let error = result as? MoyaError else {
                    return .error(BaseApiError.errorMessage(nonErrorMessage))
                }

                if case let .statusCode(status) = error {
                    if let json = try JSONSerialization.jsonObject(with: status.data, options: []) as? [String: Any] {
                        if let badRequestResponse = Mapper<Conversion>().map(JSON: json) {
                            let errorMessage = BaseApiError.errorMessage(badRequestResponse.message)
                            return .error(errorMessage)
                        }
                    }
                }
                return .error(BaseApiError.errorMessage(nonErrorMessage))
            }
    }

    class ConnectChecker {
        init () { }

        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result <URLRequest, MoyaError>) -> Void) {

            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)

            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                completion(.success(urlRequest))
                return
            }

            var flags: SCNetworkReachabilityFlags = []

            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                DispatchQueue.main.async {
//                    let url = "switchRoot"
//                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                    
//                    UIWindow(frame: UIScreen.main.bounds).switchRootViewController(rootViewController: AppNavigator.networkingConnection.viewController, animated: true, completion: nil)
                }
                completion(.failure(MoyaError.underlying(BaseApiError.errorMessage(nonErrorMessage), nil)))
                return
            }

            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)

            if isReachable && !needsConnection {
                completion(.success(urlRequest))
            } else {
                DispatchQueue.main.async {
//                    UIWindow(frame: UIScreen.main.bounds).switchRootViewController(rootViewController: AppNavigator.networkingConnection.viewController, animated: true, completion: nil)
                }
                completion(.failure(MoyaError.underlying(BaseApiError.errorMessage(nonErrorMessage), nil)))
                return
            }
        }
    }
}

