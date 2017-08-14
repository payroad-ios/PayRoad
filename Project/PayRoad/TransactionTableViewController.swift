//
//  TravelViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

class TransactionTableViewController: UIViewController {
    
    let realm = try! Realm()
    
    var travel: Travel!
    var notificationToken: NotificationToken? = nil
    
    var travelPeriodDates = [Date]()
    var dateDictionary = [String: [Transaction]]()
    var originDateList = [String]()
    var dynamicDateList = [String]()
    
    var totalAmountByCurrency = [Currency: Double]()
    var totalAmountOfFirstCurrency = 0.0
    var totalAmountIndex = 0
    
    var currentSelectedDate: Date? {
        didSet {
            filterTransaction(currentSelectedDate)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allListButton: UIButton!
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = travel.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        allListButton.isSelected = true
        allListButton.setTitleColor(UIColor.blue, for: .selected)
        allListButton.setTitleColor(UIColor.black, for: .normal)
        extractDatePeriod()
        

        notificationToken = travel.transactions.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            self?.initDataStructures()
            self?.filterTransaction(self?.currentSelectedDate)
        }
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        let moreOptionAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let travelEdit = UIAlertAction(title: "여행 수정", style: .default) { _ in
            print("여행 수정")
            
            //TODO: present(여행 수정 ViewController)
            let travelEditorViewController = UIStoryboard.loadViewController(from: .TravelEditorView, ID: "TravelEditorViewController") as! TravelEditorViewController
            travelEditorViewController.originTravel = self.travel
            travelEditorViewController.mode = .edit
            
            let navigationController = UINavigationController(rootViewController: travelEditorViewController)
            
            self.present(navigationController, animated: true, completion: nil)
        }
        
        let currencySetting = UIAlertAction(title: "통화 설정", style: .default) { [unowned self] _ in
            let currencyTableViewController = UIStoryboard.loadViewController(from: .CurrencyTableView, ID: "CurrencyTableViewController") as! CurrencyTableViewController
            let navigationController = UINavigationController(rootViewController: currencyTableViewController)
            currencyTableViewController.travel = self.travel
            
            self.present(navigationController, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        moreOptionAlertController.addAction(travelEdit)
        moreOptionAlertController.addAction(currencySetting)
        moreOptionAlertController.addAction(cancel)
        present(moreOptionAlertController, animated: true, completion: nil)
    }
    
    //TODO: 스트링 길다. 나중에 자릅시다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTransaction" {
            guard let navigationController = segue.destination as? UINavigationController,
                let addTransactionTableViewController = navigationController.topViewController as? TransactionEditorViewController
            else {
                return
            }
            addTransactionTableViewController.travel = travel
        }
        
        if segue.identifier == "editTransaction" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let navigationController = segue.destination as? UINavigationController,
                let editTransactionTableViewController = navigationController.topViewController as? TransactionEditorViewController
            else {
                return
            }
            editTransactionTableViewController.mode = .edit
            editTransactionTableViewController.travel = travel
            editTransactionTableViewController.originTransaction = travel.transactions[indexPath.row]
        }
    }
    
    func initDataStructures() {
        dateDictionary = [String: [Transaction]]()
        originDateList = [String]()
        
        for transaction in travel.transactions {
            
            guard let dateInRegion = transaction.dateInRegion else {
                return
            }
            
            let dateString = dateInRegion.string(format: .section)
            
            if dateDictionary[dateString] == nil {
                dateDictionary[dateString] = []
            }
            
            if !originDateList.contains(dateString) {
                originDateList.append(dateString)
            }
            
            dateDictionary[dateString]?.append(transaction)
            
            guard let currency = transaction.currency else {
                return
            }
            
            // TODO: Dictionary에서 Optional을 처리하는 방법?
            if totalAmountByCurrency.keys.contains(currency) {
                totalAmountByCurrency[currency]! += transaction.amount
            } else {
                totalAmountByCurrency[currency] = transaction.amount
            }
            
            totalAmountOfFirstCurrency += transaction.amount / currency.rate
        }
        
        //TODO: String sort인데, Date 포맷에 종속적이라 나중에 바꿀 필요 있음.
        originDateList.sort(by: <)
        
        // MARK: 여행가계부 앱을 참고하여 소숫점 두 자리까지만 표기
        totalAmountIndex = 0
        totalAmountTitleLabel.text = "총 지출 금액"
        totalAmountLabel.text = "\(String(format: "%.2f", totalAmountOfFirstCurrency)) \(travel.currencies.first!.code)"
    }
    
    func extractDatePeriod() {
        let dates = DateUtil.generateDatePeriod(from: travel.starteDate, to: travel.endDate)
        travelPeriodDates = dates
    }
    
    @IBAction func allListButtonDidTap(_ sender: Any) {
        allListButton.isSelected = !allListButton.isSelected
        
        currentSelectedDate = nil
        let seletedIndexPath = collectionView.indexPathsForSelectedItems
        guard let indexPath = seletedIndexPath?.first else { return }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func filterTransaction(_ selected: Date?) {
        guard let date = selected else {
            dynamicDateList = originDateList
            tableView.reloadData()
            return
        }
        
        let sectionString = DateFormatter.stringTo(for: date, format: .section)
        let filterDateList = [sectionString]
        dynamicDateList = filterDateList
        tableView.reloadData()
    }
    
    @IBAction func changeTotalAmountCurrency(_ sender: UITapGestureRecognizer) {
        if totalAmountByCurrency.count == totalAmountIndex {
            totalAmountIndex = 0
            totalAmountTitleLabel.text = "총 지출 금액"
            totalAmountLabel.text = "\(String(format: "%.2f", totalAmountOfFirstCurrency)) \(travel.currencies.first!.code)"
        } else {
            totalAmountIndex += 1
            let currency = Array(totalAmountByCurrency.keys)[totalAmountIndex - 1]
            guard let currencyAmount = totalAmountByCurrency[currency] else { return }
            totalAmountTitleLabel.text = "\(currency.code) 지출 금액"
            totalAmountLabel.text = "\(String(format: "%.2f", currencyAmount)) \(currency.code)"
        }
    }
    
}

extension TransactionTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateString = dynamicDateList[section]
        
        guard let transactions = dateDictionary[dateString] else {
            return 0
        }
        
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dynamicDateList[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        let dateString = dynamicDateList[indexPath.section]
        
        guard let transaction = dateDictionary[dateString]?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = transaction.name
        
        //TODO: 하나의 Label에 String 속성 변경하는 코드 (통화 3글자 색상 변경) -> 이 코드는 UITableViewCell이 별도의 클래스로 지정될 때 그 클래스의 내부에 선언
        let attributedString = NSMutableAttributedString(string: "\(transaction.currency?.code ?? "") \(transaction.amount)")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location: 0, length: 3))
        cell.detailTextLabel?.attributedText = attributedString
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dynamicDateList.count
    }
}
