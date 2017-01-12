//
//  CookbookAPIService.swift
//  Cookbook
//
//  Created by Dominik Vesely on 12/01/2017.
//  Copyright © 2017 Dominik Vesely. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol CookbookAPIServicing {
    func getRecipes() -> SignalProducer<Any?,RequestError>
}


/**
 Concrete class for creating api calls to our server
 */
class CookbookAPIService : APIService, CookbookAPIServicing {
    
    override func resourceURL(_ path: String) -> URL {
        let URL = Foundation.URL(string: "https://cookbook.ack.ee/api/v1/")!
        let relativeURL = Foundation.URL(string: path, relativeTo: URL)!
        return relativeURL
    }
    
    internal func getRecipes() -> SignalProducer<Any?, RequestError> {
        return self.request("recipes")
            .mapError { .network($0) }
           // .map{ Any? -> Array Of Recipes}
    }

    
}
