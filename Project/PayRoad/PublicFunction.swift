//
//  PublicFunction.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 9..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit
import RealmSwift

public let realm = try! Realm()

public func tableViewNotificationToken<T>(for tableView: UITableView, list: List<T>? = nil, results: Results<T>? = nil) -> NotificationToken {
    var notificationToken = NotificationToken()
    
    // Observe Results Notifications
    let closure: (RealmCollectionChange<AnyRealmCollection<T>>) -> Void = { (changes: RealmCollectionChange) in
        switch changes {
        case .initial:
            // Results are now populated and can be accessed without blocking the UI
            tableView.reloadData()
            break
        case .update(_, let deletions, let insertions, let modifications):
            // Query results have changed, so apply them to the UITableView
            tableView.beginUpdates()
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                                 with: .automatic)
            tableView.endUpdates()
            break
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
            break
        }
    }
    
    if list == nil {
        notificationToken = results!._addNotificationBlock(closure)
    } else {
        notificationToken = list!._addNotificationBlock(closure)
    }
    return notificationToken
}

