//
//  AppDelegate.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/25/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import UIKit

#if (arch(i386) || arch(x86_64))
    let isSimulator = true
#else
    let isSimulator = false
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil)
        -> Bool {
            
            guard let navigation = window?.rootViewController as? UINavigationController else {
                return false
            }
            
            let scanerViewModel = QRScanerViewController.ViewModel { payload in
                parse(payload: payload) {
                    guard let bill = $0 else { return }
                    
                    DispatchQueue.main.async {
                        guard let billViewController = navigation.storyboard?.instantiateViewController(
                            withIdentifier: "Bill details") as? BillViewController else {
                                fatalError("Cannot instantiate bill details")
                        }
                        
                        billViewController.viewModel = .init(bill: bill)
                        navigation.pushViewController(billViewController, animated: true)
                    }
                }
            }
            
            if isSimulator {
                guard let testScaner = navigation.storyboard?.instantiateViewController(
                    withIdentifier: "Test scaner") as? TestScanerViewController else {
                        fatalError("Cannot instantiate test scaner")
                }
                
                testScaner.viewModel = scanerViewModel
                navigation.viewControllers = [testScaner]
            } else {
                guard let qrScaner = navigation.storyboard?.instantiateViewController(
                    withIdentifier: "QR scaner") as? QRScanerViewController else {
                        fatalError("Cannot instantiate qr scaner")
                }
                
                qrScaner.viewModel = scanerViewModel
                navigation.viewControllers = [qrScaner]
            }
            
            return true
    }
}

