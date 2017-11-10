//
//  CookbookAPIService.swift
//  Cookbook
//
//  Created by Dominik Vesely on 12/01/2017.
//  Copyright © 2017 Dominik Vesely. All rights reserved.
//

import Foundation
import ReactiveSwift
import Argo

protocol CookbookAPIServicing {
    /// Does the same as getRecipes(onSuccess:, onError)
    func getRecipes() -> SignalProducer<[Recipe]?, RequestError>
    /// Use this primarily as it does not add complexity with ReactiveSwift/ReactiveCocoa
    func getRecipes(onSuccess: @escaping ([Recipe]?) -> Void,
                    onError: @escaping (RequestError) -> Void)
}

/**
 Concrete class for creating api calls to our server
 */
class CookbookAPIService: APIService, CookbookAPIServicing {
    override func resourceURL(_ path: String) -> URL {
        let URL = Foundation.URL(string: "https://cookbook.ack.ee/api/v1/")!
        let relativeURL = Foundation.URL(string: path, relativeTo: URL)!
        return relativeURL
    }

    internal func getRecipes() -> SignalProducer<[Recipe]?, RequestError> {
        return self.request("recipes")
            .map { anyJSON -> [Recipe]? in
                guard let anyJSON = anyJSON else { return nil }
                return decode(anyJSON)
            }
            .mapError { .network($0) }
    }

    internal func getRecipes(onSuccess: @escaping ([Recipe]?) -> Void,
                             onError: @escaping (RequestError) -> Void) {
        self.getRecipes().on(event: { event in
            switch event {
            case let .value(recipes): onSuccess(recipes)
            case let .failed(error): onError(error)
            case .interrupted: onError(.interrupted)
            case .completed: break
            }
        }).start()
    }
}
