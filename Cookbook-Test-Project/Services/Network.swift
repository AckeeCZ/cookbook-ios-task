//
//  Network.swift
//  Cookbook-Test-Project
//
//  Created by Tomas Kohout on 1/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import Reqres

struct NetworkError: Error {
    let error: NSError
    let request: URLRequest?
    let response: HTTPURLResponse?
}

protocol Networking {
    func request(_ url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<Any?, NetworkError>
}

class Network: Networking {
    
    let alamofireManager : SessionManager
    
    init() {
        let configuration = Reqres.defaultSessionConfiguration()
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        alamofireManager =  Alamofire.SessionManager(configuration: configuration)
    }

    func request(_ url: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]?, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<Any?, NetworkError> {
        return SignalProducer { sink, disposable in
            let request = self.alamofireManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .response() { let request = $0.request; let response = $0.response; let data = $0.data; let error = $0.error

                    switch (data, error) {
                    case (_, .some(let e)):
                        sink.send(error: NetworkError(error: e as NSError, request: request, response: response))
                    case (.some(let d), _):
                        do {
                            let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                            sink.send(value: json)
                            sink.sendCompleted()
                        } catch {
                            sink.send(error: NetworkError(error: (error as NSError), request: request, response: response))
                            return
                        }
                    default: assertionFailure()
                    }
            }

            if useDisposables {
                disposable.observeEnded {
                    request.cancel()
                }
            }
        }
    }
    
}
