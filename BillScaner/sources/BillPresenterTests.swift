//
//  BillPresenterTests.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/25/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import XCTest
@testable import BillScaner

class BillPresenterTests: XCTestCase {
    
    func testEmptyBill() {
        let bill = Bill(items: [])
        let viewModel = BillViewController.ViewModel(bill: bill)
        
        guard viewModel.items.count == 1 else { return XCTFail() }
        XCTAssertEqual(viewModel.items[0].sum, localizedFormatter(sum: 0))
        XCTAssertEqual(viewModel.items[0].title, "Total")
    }
    
    func testSingleItemBill() {
        let bill = try! Bill(items: [Bill.Item(title: "Test", count: 5, cost: 5.5)])
        let viewModel = BillViewController.ViewModel(bill: bill)
        
        guard viewModel.items.count == 2 else { return XCTFail() }
        XCTAssertEqual(viewModel.items[0].sum, localizedFormatter(sum: 27.5))
        XCTAssertEqual(viewModel.items[0].title, "Test")
        XCTAssertEqual(viewModel.items[1].sum, localizedFormatter(sum: 27.5))
        XCTAssertEqual(viewModel.items[1].title, "Total")
    }
    
    func testManyItemsBill() {
        let bill = try! Bill(items: [
            Bill.Item(title: "Test 1", count: 5, cost: 5.5),
            Bill.Item(title: "Test 2", count: 1, cost: 10) ])
        let viewModel = BillViewController.ViewModel(bill: bill)
        
        guard viewModel.items.count == 3 else { return XCTFail() }
        XCTAssertEqual(viewModel.items[0].sum, localizedFormatter(sum: 27.5))
        XCTAssertEqual(viewModel.items[0].title, "Test 1")
        XCTAssertEqual(viewModel.items[1].sum, localizedFormatter(sum: 10))
        XCTAssertEqual(viewModel.items[1].title, "Test 2")
        XCTAssertEqual(viewModel.items[2].sum, localizedFormatter(sum: 37.5))
        XCTAssertEqual(viewModel.items[2].title, "Total")
    }
}
