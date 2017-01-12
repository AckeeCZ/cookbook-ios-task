//
//  APIService.swift
//  Bazos
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import Result
//import ACKReactiveExtensions

typealias AuthHandler = Action<NetworkError, (), NSError>

//Base class which all API Services should inherit

enum RequestError: Error {
    case network(NetworkError)
    case mapping()
}

class APIService {
    // MARK: Dependencies
     let network: Networking
     let authHandler: AuthHandler?

    init(network: Networking, authHandler: AuthHandler?) {
        self.network = network
        self.authHandler = authHandler
    }

    func resourceURL(_ path: String) -> URL {
        let URL = Foundation.URL(string: "")!
        let relativeURL = Foundation.URL(string: path, relativeTo: URL)!
        return relativeURL
    }

    func request(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:], authHandler: AuthHandler? = nil) -> SignalProducer<Any?, NetworkError> {
        let relativeURL = resourceURL(path)
        return self.network.request(relativeURL.absoluteString, method: method, parameters: parameters, encoding: encoding, headers: headers, useDisposables: false)
            .flatMapError { [unowned self] networkError in
                guard networkError.response?.statusCode == 401,
                    let authHandler = authHandler,
                    let originalRequest = networkError.request
                else { return SignalProducer(error: networkError) }
                
                let retry = { [unowned self] in
                    self.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers, authHandler: authHandler)
                }

                guard self.requestUsedCurrentAuthData(originalRequest) else { return retry() } // check that we havent refreshed token while the request was running

                let refreshSuccessful = SignalProducer(signal: authHandler.events)
                    .filter { $0.isTerminating } // dont care about values
                .map { e -> Bool in
                    switch e {
                    case .completed: return true
                    case .failed, .interrupted: return false
                    default: assertionFailure(); return false
                    }
                }
                    .take(first: 1)

                return refreshSuccessful
                    .on(started: {
                        DispatchQueue.main.async { // fire the authHandler in next runloop to prevent recursive events in case that authHandler completes synchronously
                            authHandler.apply(networkError).start() // sideeffect
                        }
                })
                    .promoteErrors(NetworkError.self)
                    .flatMap(.latest) { success -> SignalProducer<Any?, NetworkError> in
                        guard success else { return SignalProducer(error: networkError) }
                        return retry()
                }
        }
    }
    

    func requestUsedCurrentAuthData(_ request: URLRequest) -> Bool {
        return true
    }
}
