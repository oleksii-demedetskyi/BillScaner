//
//  ViewController.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/25/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import UIKit

class BillViewController: UITableViewController {
    struct ViewModel {
        struct Item {
            let title: String
            let sum: String
        }
        let items: [Item]
    }
    
    var viewModel = ViewModel(items: [
        ViewModel.Item(title: "Meal 1 x 5", sum: "$25.00"),
        ViewModel.Item(title: "Meal 2", sum: "$10.00"),
        ViewModel.Item(title: "Total", sum: "$35.00")]) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError("cannot fetch cell from storyboard")
        }
        
        let item = viewModel.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.sum
        
        return cell
    }
}

