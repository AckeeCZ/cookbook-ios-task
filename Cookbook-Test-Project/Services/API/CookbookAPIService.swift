//
//  CookbookAPIService.swift
//  Cookbook-Test-Project
//
//  Created by Dominik Vesely on 12/01/2017.
//  Copyright © 2017 Dominik Vesely. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol CookbookAPIServicing {
    func getRecipes() -> SignalProducer<Any?,RequestError>
}

/// Concrete class for creating api calls to our server
class CookbookAPIService : APIService, CookbookAPIServicing {

    private static let baseURL = URL(string: "https://cookbook.ack.ee/api/v1/")!
    
    override func resourceURL(for path: String) -> URL {
        return CookbookAPIService.baseURL.appendingPathComponent(path)
    }

    // MARK: CookbookAPIServicing
    
    internal func getRecipes() -> SignalProducer<Any?, RequestError> {
        return request("recipes")
            .mapError { .network($0) }
           // .map{ Any? -> Array Of Recipes}
    }
}
