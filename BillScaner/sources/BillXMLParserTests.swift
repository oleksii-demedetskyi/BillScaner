//
//  BillXMLParserTests.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/26/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import XCTest
@testable import BillScaner

class BillXMLParserTests: XCTestCase {
    
    func testDemoXML() {
        guard let url = Bundle.main.url(forResource: "TestXMLPayload", withExtension: "xml") else {
            fatalError("Cannot load demo xml")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return XCTFail("Cannot read data from url: \(url)")
        }
        guard let bill = try? Bill(xml: data) else {
            return XCTFail("Cannot construct bill from xml")
        }
        
        guard bill.items.count == 4 else { return XCTFail("Incorrect number of parsed items") }
        
        // Order is like in XML.
        XCTAssertEqual(bill.items[0].title, "cake")
        XCTAssertEqual(bill.items[0].count, 2)
        XCTAssertEqual(bill.items[0].cost, 1.99)
        
        XCTAssertEqual(bill.items[1].title, "coffee")
        XCTAssertEqual(bill.items[1].count, 1)
        XCTAssertEqual(bill.items[1].cost, 1.39)
        
        XCTAssertEqual(bill.items[2].title, "juice")
        XCTAssertEqual(bill.items[2].count, 1)
        XCTAssertEqual(bill.items[2].cost, 1.45)
        
        XCTAssertEqual(bill.items[3].title, "scrumble")
        XCTAssertEqual(bill.items[3].count, 2)
        XCTAssertEqual(bill.items[3].cost, 2.99)
    }
}
