//
//  Recipe.swift
//  Cookbook
//
//  Created by Michal Štembera on 10/11/2017.
//  Copyright © 2017 Dominik Vesely. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Recipe {
    let id: String
    let name: String
    let duration: Int
    let score: Double
}

extension Recipe: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Recipe> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "duration"
            <*> json <| "score"
    }
}
