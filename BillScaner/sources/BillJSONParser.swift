//
//  BillJSONParser.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/25/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import Foundation

extension Bill {
    
    enum JSONParsingError: Error {
        case jsonIsNotAnObject(Any)
        case itemIsNotAnObjec(Any)
        case itemIsIncorrect([String: Any])
    }
    
    init(json payload: Data) throws {
        try self.init(json: JSONSerialization.jsonObject(with: payload))
    }
    
    init(json jsonObject: Any) throws {
        guard let json = jsonObject as? [String: Any] else {
            throw JSONParsingError.jsonIsNotAnObject(jsonObject)
        }
        
        self.items = try json.map { _, jsonObject in
            guard let json = jsonObject as? [String: Any] else {
                throw JSONParsingError.itemIsNotAnObjec(jsonObject)
            }
            guard let name = json["name"] as? String,
                let price = json["price"] as? NSNumber,
                let quantity = json["quantity"] as? NSNumber else {
                    throw JSONParsingError.itemIsIncorrect(json)
            }
            
            return try Bill.Item(title: name, count: quantity.intValue, cost: price.floatValue)
        }
    }
}
