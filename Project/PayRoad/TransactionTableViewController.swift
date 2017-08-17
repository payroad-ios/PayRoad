//
//  TravelViewController.swift
//  PayRoad
//
//  Created by Febrix on 2017. 8. 8..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

import RealmSwift

enum PaymentType {
    case all
    case cash
    case card
}

class TransactionTableViewController: UIViewController {
    
    let realm = try! Realm()
    
    var travel: Travel!
    var sortedTransactions: Results<Transaction>!

    var transactionsNotificationToken: NotificationToken? = nil
    var travelNotificationToken: NotificationToken? = nil
    
    var travelPeriodDates = [YMD]()
    var dateDictionary = [YMD: [Transaction]]()
    var originDateList = [YMD]()
    var dynamicDateList = [YMD]()
    
    var currentPaymentType = PaymentType.all
    var totalSpendingIndex = 0
    var totalSpendingByYMD = [YMD: Double]()
    var totalSpendingByCurrency = [Currency: Double]()
    var totalSpendingOfFirstCurrency = 0.0
    
    var currentSelectedDate: YMD? {
        didSet {
            filterTransaction(selected: currentSelectedDate)
        }
    }
    
    var pullToAddLabel = UILabel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allListButton: UIButton!
    
    @IBOutlet weak var paymentTypeButton: UIButton!
    @IBOutlet weak var spendingLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = travel.name
        sortedTransactions = travel.transactions.filter("isCash == true").sorted(byKeyPath: "dateInRegion.date", ascending: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = ColorStore.placeHolderGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        pullToAddLabel.textColor = ColorStore.basicBlack
        pullToAddLabel.backgroundColor = ColorStore.lightestGray
        pullToAddLabel.textAlignment = .center
        pullToAddLabel.clipsToBounds = true
        tableView.addSubview(pullToAddLabel)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        allListButton.isSelected = true
        allListButton.setTitleColor(ColorStore.darkGray, for: .normal)
        allListButton.setTitleColor(ColorStore.darkGray, for: .selected)
        allListButton.backgroundColor = ColorStore.pastelYellow
        extractDatePeriod()
        
        transactionsNotificationToken = travel.transactions.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.initDataStructures()
            self?.filterTransaction(selected: self?.currentSelectedDate)
            self?.displayTotalSpendingCurrency()
        }
        
        
        //NotificationToken 미 해제 시 해당 객체 삭제 불가. (에러 호출)
//        travelNotificationToken = travel.addNotificationBlock{ [weak self] _ in
//            self?.extractDatePeriod()
//            self?.collectionView.reloadData()
//        }
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        let moreOptionAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let travelEdit = UIAlertAction(title: "여행 수정", style: .default) { _ in
            print("여행 수정")
            
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
        if segue.identifier == "editTransaction" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let navigationController = segue.destination as? UINavigationController,
                let editTransactionTableViewController = navigationController.topViewController as? TransactionEditorViewController
                else {
                    return
            }
            let key = dynamicDateList[indexPath.section]
            let selectedTransaction = dateDictionary[key]?[indexPath.row]
            
            editTransactionTableViewController.mode = .edit
            editTransactionTableViewController.travel = travel
            editTransactionTableViewController.originTransaction = selectedTransaction
            editTransactionTableViewController.standardDate = selectedTransaction?.dateInRegion
        }
    }
    
    func initDataStructures() {
        dateDictionary = [YMD: [Transaction]]()
        originDateList = [YMD]()
        
        totalSpendingByYMD = [YMD: Double]()
        totalSpendingByCurrency = [Currency: Double]()
        totalSpendingOfFirstCurrency = 0.0
        
        for transaction in sortedTransactions {
            
            guard let ymd = transaction.dateInRegion?.ymd,
                let currency = transaction.currency else { return }
            
            if dateDictionary[ymd] == nil {
                dateDictionary[ymd] = []
            }
            
            if !originDateList.contains(ymd) {
                originDateList.append(ymd)
            }
            
            dateDictionary[ymd]?.append(transaction)
            
            if var totalAmount = totalSpendingByCurrency[currency] {
                totalAmount += transaction.amount
                totalSpendingByCurrency[currency] = totalAmount
            } else {
                totalSpendingByCurrency[currency] = transaction.amount
            }
            
            if var totalAmount = totalSpendingByYMD[ymd] {
                totalAmount += transaction.amount / currency.rate
                totalSpendingByYMD[ymd] = totalAmount
            } else {
                totalSpendingByYMD[ymd] = transaction.amount / currency.rate
            }
            
        }
        
        originDateList.sort(by: >)
        
        for amount in totalSpendingByYMD.values {
            totalSpendingOfFirstCurrency += amount
        }
    }
    
    func filterTransaction(selected: YMD?) {
        defer {
            tableView.reloadData()
        }
        guard let date = selected else {
            dynamicDateList = originDateList
            return
        }
        dynamicDateList = [date]
    }
    
    func extractDatePeriod() {
        let startYMD = YMD(year: travel.startYear, month: travel.startMonth, day: travel.startDay)
        let endYMD = YMD(year: travel.endYear, month: travel.endMonth, day: travel.endDay)
        let dates = DateUtil.generateYMDPeriod(from: startYMD, to: endYMD)
        travelPeriodDates = dates
    }
    
    @IBAction func allListButtonDidTap(_ sender: Any) {
        allListButton.isSelected = true
        allListButton.backgroundColor = allListButton.isSelected ? ColorStore.pastelYellow : UIColor.white
        
        currentSelectedDate = nil
        let seletedIndexPath = collectionView.indexPathsForSelectedItems
        guard let indexPath = seletedIndexPath?.first else { return }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    @IBAction func paymentTypeButtonDidTap(_ sender: Any) {
        switch currentPaymentType {
        case .all:
            currentPaymentType = .cash
            paymentTypeButton.setTitle("현금", for: .normal)
            sortedTransactions = travel.transactions.filter("isCash == true").sorted(byKeyPath: "dateInRegion.date", ascending: false)
        case .cash:
            currentPaymentType = .card
            paymentTypeButton.setTitle("카드", for: .normal)
            sortedTransactions = travel.transactions.filter("isCash == false").sorted(byKeyPath: "dateInRegion.date", ascending: false)
        case .card:
            currentPaymentType = .all
            paymentTypeButton.setTitle("전체", for: .normal)
            sortedTransactions = travel.transactions.sorted(byKeyPath: "dateInRegion.date", ascending: false)
        }
        
        initDataStructures()
        filterTransaction(selected: currentSelectedDate)
        displayTotalSpendingCurrency()
    }
    
    @IBAction func totalSpendingViewDidTap(_ sender: Any) {
        totalSpendingIndex += 1
        displayTotalSpendingCurrency()
    }
    
    func displayTotalSpendingCurrency() {
        if totalSpendingIndex >= travel.currencies.count {
            totalSpendingIndex = 0
        }
        
        let currency = travel.currencies[totalSpendingIndex]
        var spendingRate = 0.0
        
        if let amountByCurrency = totalSpendingByCurrency[currency] {
            spendingLabel.text = "\(String(format: "%.2f", amountByCurrency)) \(currency.code)"
            balanceLabel.text = "\(currency.budget - amountByCurrency) \(currency.code)"
            spendingRate = amountByCurrency / currency.budget
        } else {
            spendingLabel.text = "0 \(currency.code)"
            balanceLabel.text = "\(currency.budget) \(currency.code)"
        }
        
        if spendingRate < 0 || spendingRate > 1 {
            spendingRate = 1
        }
        
        percentageLabel.text = "\(String(format: "%.0f", spendingRate * 100))%"
    }
    
    deinit {
        transactionsNotificationToken?.stop()
        travelNotificationToken?.stop()
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
        let ymd = dynamicDateList[section]
        
        if let totalAmount = totalSpendingByYMD[ymd] {
            return "  \(dynamicDateList[section].string()) (\(String(format: "%.2f", totalAmount)) \(travel.currencies.first!.code))"
        }
        
        return "  \(dynamicDateList[section].string())"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSelectedDate != nil {
            return 1
        }
        
        return dynamicDateList.count
    }
}

extension TransactionTableViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentOffset.y
        pullToAddLabel.frame = CGRect(x: 0, y: height, width: view.frame.width, height: -height)
        pullToAddLabel.text = !(scrollView.contentOffset.y >= -50) ? "놓아서 새 항목 추가" : "당겨서 새 항목 추가"
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let transactionEditorViewController = UIStoryboard.loadViewController(from: .TransactionEditorView, ID: "TransactionEditorViewController") as! TransactionEditorViewController
        let navigationController = UINavigationController(rootViewController: transactionEditorViewController)
        
        if scrollView.restorationIdentifier == "transactionTableView" && !(scrollView.contentOffset.y >= -50) && velocity.y >= -3.5 {
            let dateInRegion = DateInRegion()
            if let selectedDate = currentSelectedDate {
                dateInRegion.date = selectedDate.compareRangeOfDate(date: Date()) ? Date() : selectedDate.date
            } else {
                dateInRegion.date = Date()
            }

            transactionEditorViewController.travel = travel
            transactionEditorViewController.standardDate = dateInRegion
            present(navigationController, animated: true, completion: nil)
        }
    }
}

//MARK:- DateSelect CollectionView Delegate, DataSource

extension TransactionTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return travelPeriodDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateSelectCollectionViewCell
        let travelPeriodDate = travelPeriodDates[indexPath.row]
        cell.dayLabel.text = "\(travelPeriodDate.day)\n\(travelPeriodDate.monthName)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        allListButton.isSelected = false
        allListButton.backgroundColor = allListButton.isSelected ? ColorStore.pastelYellow : UIColor.white
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
