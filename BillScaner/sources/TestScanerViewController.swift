//
//  TestScanerViewController.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/26/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import UIKit

class TestScanerViewController: UIViewController {
    var viewModel = QRScanerViewController.ViewModel { _ in }
    
    @IBAction func testJSONPayload() {
        let payload = try! Data(
            contentsOf: Bundle.main.url(forResource: "TestJSONPayload", withExtension: "json")!
        )
        
        viewModel.processPayload(payload)
    }
    
    @IBAction func testXMLPayload() {
        let payload = try! Data(
            contentsOf: Bundle.main.url(forResource: "TestXMLPayload", withExtension: "xml")!
        )
        
        viewModel.processPayload(payload)
    }
    
    @IBAction func testURLPayload() {
        let url = "https://ios-devchallenge-11.firebaseio.com/order_id.json"
        let payload = url.data(using: .utf8)!
        viewModel.processPayload(payload)
    }
}
