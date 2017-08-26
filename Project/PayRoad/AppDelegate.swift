//
//  AppDelegate.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum ShortcutItemType: String {
        case addTravel = "AddTravel"
        case addTransaction = "AddTransaction"
    }
    
    var window: UIWindow?
    
    let realm = try! Realm()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        RealmInitializer.initializeCategories()

        //UINavigationBar customize
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = ColorStore.basicBlack
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : ColorStore.basicBlack]
        
        // Google Maps, Place initialize API Keys
        GMSServices.provideAPIKey(kMapsAPIKey)
        GMSPlacesClient.provideAPIKey(kPlacesAPIKey)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem))
    }
    
    func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var quickActionHandled = false
        
        let type = shortcutItem.type.components(separatedBy: ".").last!
        if let shortcutItemType = ShortcutItemType.init(rawValue: type) {
            
            let travelTableViewController = UIStoryboard.loadViewController(from: .TravelTableView, ID: "TravelTableViewController") as! TravelTableViewController
            let navigationController = UINavigationController(rootViewController: travelTableViewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            
            switch shortcutItemType {
            case .addTravel:
                travelTableViewController.performSegue(withIdentifier: "addTravel", sender: nil)
                quickActionHandled = true
            
            case .addTransaction:
                guard let travel = realm.objects(Transaction.self).last?.travel.first else {
                    return false
                }
                
                let transactionTableViewController = UIStoryboard.loadViewController(from: .TransactionTableView, ID: "Travel") as! TransactionTableViewController
                transactionTableViewController.travel = travel
                navigationController.pushViewController(transactionTableViewController, animated: false)
                
                let transactionEditorViewController = UIStoryboard.loadViewController(from: .TransactionEditorView, ID: "TransactionEditorViewController") as! TransactionEditorViewController
                transactionEditorViewController.travel = travel
                
                let transactionEditorNavigationController = UINavigationController(rootViewController: transactionEditorViewController)
                
                self.window?.rootViewController?.present(transactionEditorNavigationController, animated: true, completion: nil)
                quickActionHandled = true
            }
        }
        
        return quickActionHandled
    }
}

