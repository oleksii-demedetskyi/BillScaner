//
//  BillJSONParserTests.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/26/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import XCTest
@testable import BillScaner

class BillJSONParserTests: XCTestCase {
    
    func testDemoJSON() {
        let json: [String: Any] = [
            "cake_id": ["name": "cake", "price": 1.99, "quantity": 2],
            "coffee_id": ["name": "coffee", "price": 1.39, "quantity": 1],
            "juice_id": ["name": "juice", "price": 1.45, "quantity": 1],
            "scrumble_id": ["name": "scrumble", "price": 2.99, "quantity": 2],
        ]
        
        let bill = try! Bill(json: json)
        
        guard bill.items.count == 4 else { return XCTFail("Incorrect number of parsed items") }
        
        // Order is impl dependent.
        XCTAssertEqual(bill.items[0].title, "cake")
        XCTAssertEqual(bill.items[0].count, 2)
        XCTAssertEqual(bill.items[0].cost, 1.99)
        
        XCTAssertEqual(bill.items[1].title, "scrumble")
        XCTAssertEqual(bill.items[1].count, 2)
        XCTAssertEqual(bill.items[1].cost, 2.99)
        
        XCTAssertEqual(bill.items[2].title, "juice")
        XCTAssertEqual(bill.items[2].count, 1)
        XCTAssertEqual(bill.items[2].cost, 1.45)
        
        XCTAssertEqual(bill.items[3].title, "coffee")
        XCTAssertEqual(bill.items[3].count, 1)
        XCTAssertEqual(bill.items[3].cost, 1.39)
        
    }
    
}
