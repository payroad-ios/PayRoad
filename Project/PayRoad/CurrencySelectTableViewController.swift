//
//  CurrencySelectTableViewController.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 9..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

protocol CurrencySelectTableViewControllerDelegate {
    
    func currencySelectResponse(code: String)
}

class CurrencySelectTableViewController: UITableViewController, UISearchBarDelegate {
    
    var delegate: CurrencySelectTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "화폐"
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension CurrencySelectTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Locale.commonISOCurrencyCodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyItemCell", for: indexPath)
        
        let currencyCode = Locale.commonISOCurrencyCodes[indexPath.row]
        cell.textLabel?.text = Locale.current.localizedString(forCurrencyCode: currencyCode)
        cell.detailTextLabel?.text = currencyCode
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let code = Locale.commonISOCurrencyCodes[indexPath.row]
        self.delegate?.currencySelectResponse(code: code)
        self.navigationController?.popViewController(animated: true)
        
    }
}
