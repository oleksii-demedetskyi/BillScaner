//
//  Bill.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/25/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import Foundation

struct Bill {
    struct Item {
        let title: String
        let count: Int
        let cost: Float
        
        enum Error: Swift.Error {
            case emptyTitle, zeroCount, negativeCost
        }
        
        init(title: String, count: Int, cost: Float) throws {
            guard !title.isEmpty else { throw Error.emptyTitle }
            guard count > 0 else { throw Error.zeroCount }
            guard cost >= 0 else { throw Error.negativeCost }
            
            self.title = title
            self.count = count
            self.cost = cost
        }
    }
    
    let items: [Item]
}
