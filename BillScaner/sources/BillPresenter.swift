//
//  BillPresenter.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/25/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import Foundation

let moneyFormatter: NumberFormatter = {
    var formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
}()

func localizedFormatter(sum: Float) -> String {
    guard let result = moneyFormatter.string(from: sum as NSNumber) else {
        fatalError("Cannot format sum: \(sum)")
    }
    
    return result
}

extension BillViewController.ViewModel {
    init(bill: Bill, formatter: (Float) -> String = localizedFormatter) {
        var total: Float = 0.0
        var items: [Item] = bill.items.map { item in
            let sum: Float = item.cost * .init(item.count)
            total += sum
    
            return Item(title: item.title, sum: formatter(sum))
        }
        
        items.append(Item(title: "Total", sum: formatter(total)))
        
        self.items = items
    }
}
