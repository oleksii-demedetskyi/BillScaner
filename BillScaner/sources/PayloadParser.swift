//
//  PayloadParser.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/26/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import Foundation

func parse(payload: Data, callback: @escaping (Bill?) -> Void) {
    if let string = String(data: payload, encoding: .utf8), let url = URL(string: string) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                parse(payload: data, callback: callback)
            }
        }
        task.resume()
    } else if let bill = try? Bill(xml: payload) {
        callback(bill)
    } else if let bill = try? Bill(json: payload) {
        callback(bill)
    }
}
