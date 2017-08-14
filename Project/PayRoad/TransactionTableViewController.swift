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
    var transactions: Results<Transaction>!

    var notificationToken: NotificationToken? = nil
    
    var travelPeriodDates = [YMD]()
    var dateDictionary = [YMD: [Transaction]]()
    var dateList = [YMD]()
    
    var totalAmountByCurrency = [Currency: Double]()
    var totalAmountOfFirstCurrency = 0.0
    var totalAmountIndex = 0
    
    var currentSelectedDate: YMD? {
        didSet {
            self.tableView.reloadData()
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
        transactions = travel.transactions.sorted(byKeyPath: "dateInRegion.date", ascending: false)
        
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
            self?.initDataStructures()
            self?.tableView.reloadData()
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
        dateDictionary = [YMD: [Transaction]]()
        dateList = [YMD]()
        
        totalAmountByCurrency = [Currency: Double]()
        totalAmountOfFirstCurrency = 0.0
        
        for transaction in transactions {
            
            guard let dateInRegion = transaction.dateInRegion else {
                return
            }
            
            if dateDictionary[dateInRegion.ymd] == nil {
                dateDictionary[dateInRegion.ymd] = []
            }
            
            if !dateList.contains(dateInRegion.ymd) {
                dateList.append(dateInRegion.ymd)
            }
            
            dateDictionary[dateInRegion.ymd]?.append(transaction)
            
            guard let currency = transaction.currency else {
                return
            }
            
            if var totalAmount = totalAmountByCurrency[currency] {
                totalAmount += transaction.amount
                totalAmountByCurrency[currency] = totalAmount
            } else {
                totalAmountByCurrency[currency] = transaction.amount
            }
            
            totalAmountOfFirstCurrency += transaction.amount / currency.rate
        }
        
        dateList.sort(by: >)
        
        // MARK: 여행가계부 앱을 참고하여 소숫점 두 자리까지만 표기
        totalAmountIndex = 0
        totalAmountTitleLabel.text = "총 지출 금액"
        totalAmountLabel.text = "\(String(format: "%.2f", totalAmountOfFirstCurrency)) \(travel.currencies.first!.code)"
    }
    
    func extractDatePeriod() {
        let startYMD = YMD(year: travel.startYear, month: travel.startMonth, day: travel.startDay)
        let endYMD = YMD(year: travel.endYear, month: travel.endMonth, day: travel.endDay)
        let dates = DateUtil.generateYMDPeriod(from: startYMD, to: endYMD)
        travelPeriodDates = dates
    }
    
    @IBAction func allListButtonDidTap(_ sender: Any) {
        allListButton.isSelected = !allListButton.isSelected
        
        currentSelectedDate = nil
        let seletedIndexPath = collectionView.indexPathsForSelectedItems
        guard let indexPath = seletedIndexPath?.first else { return }
        collectionView.deselectItem(at: indexPath, animated: false)
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
        
        let transactions: [Transaction]?
        
        if let currentSelectedDate = currentSelectedDate {
            transactions = dateDictionary[currentSelectedDate]
        } else {
            transactions = dateDictionary[dateList[section]]
        }
        
        if let transactions = transactions {
            return transactions.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let currentSelectedDate = currentSelectedDate {
            return currentSelectedDate.string()
        }
        
        return dateList[section].string()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let transactions: [Transaction]
        
        if let currentSelectedDate = currentSelectedDate {
            transactions = dateDictionary[currentSelectedDate]!
        } else {
            transactions = dateDictionary[dateList[indexPath.section]]!
        }
        
        let transaction: Transaction = transactions[indexPath.row]
        
        cell.textLabel?.text = transaction.name
        
        //TODO: 하나의 Label에 String 속성 변경하는 코드 (통화 3글자 색상 변경) -> 이 코드는 UITableViewCell이 별도의 클래스로 지정될 때 그 클래스의 내부에 선언
        let attributedString = NSMutableAttributedString(string: "\(transaction.currency?.code ?? "") \(transaction.amount)")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location: 0, length: 3))
        cell.detailTextLabel?.attributedText = attributedString
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSelectedDate != nil {
            return 1
        }
        
        return dateList.count
    }
}

//MARK:- DateSelect CollectionView Delegate, DataSource

extension TransactionTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelPeriodDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateSelectCollectionViewCell
        cell.dayLabel.text = "\(travelPeriodDates[indexPath.row].day)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        allListButton.isSelected = false
        currentSelectedDate = travelPeriodDates[indexPath.row]
    }
}

extension TransactionTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
