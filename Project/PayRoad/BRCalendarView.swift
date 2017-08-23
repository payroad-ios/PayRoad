//
//  BRCalendarView.swift
//  PayRoad_CalendarPractice
//
//  Created by Febrix on 2017. 8. 22..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

enum CollectionViewType: String {
    case days = "days"
    case month = "month"
}

@IBDesignable class BRCalendarView: UIView, BRCalendarDelegate {
    
    let cellId = "monthCell"
    var dateOfMonthArray = [Date]()
    var willIndexPath = Int()
    var currentIndexPath = Int()
    var todayDate: Date!
    var startOfMonthDate: Date!
    let brCalendar = BRCalendarFormatter()
    let rangeMonth = 24
    var selectedDate: Date? = nil
    
    var delegate: BRCalendarDelegate?
    var target: UIViewController?
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        let bounds = UIScreen.main.bounds
        let customFrame = CGRect(x: 0, y: 0, width: bounds.width, height: 300)
        super.init(frame: customFrame)
        setupView()
        
        let nib = UINib(nibName: "BRCalendarMonthCollectionViewCell", bundle: nil)
        monthCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.showsHorizontalScrollIndicator = false
        monthCollectionView.isPagingEnabled = true
        monthCollectionView.backgroundColor = UIColor.gray
        selectDate(date: Date(), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func selectDate(date: Date?, animated: Bool) {
        let startOfDay = brCalendar.startOfDay(for: date ?? Date())
        setupCalendarDate(rangeMonth: rangeMonth, centerDate: date ?? Date())
        let indexPath = IndexPath(row: rangeMonth, section: 0)
        monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        monthCollectionView.reloadItems(at: [indexPath])
        let cell = monthCollectionView.cellForItem(at: indexPath) as? BRCalendarMonthCollectionViewCell
        cell?.selectDay(date: startOfDay, animated: animated)
    }
    
    private func setupCalendarDate(rangeMonth: Int, centerDate: Date) {
        todayDate = brCalendar.startOfDay(for: centerDate)
        startOfMonthDate = brCalendar.startOfMonth(for: todayDate)
        
        var tempArray = [Date]()
        let setCenterForDate = brCalendar.date(byAdding: .month, value: -rangeMonth, to: startOfMonthDate)
        for i in 0...rangeMonth * 2 {
            let addingDate = brCalendar.date(byAdding: .month, value: i, to: setCenterForDate)
            tempArray.append(addingDate)
        }
        dateOfMonthArray = tempArray
        monthCollectionView.reloadData()
    }
    
    private func setupView() {
        let view = viewFromNib()
        
        view.frame = bounds
        view.backgroundColor = UIColor.gray
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        view.layoutIfNeeded()
        view.layoutSubviews()
        addSubview(view)
        view.addUpperline(color: ColorStore.blackLayer, borderWidth: 0.5)
    }
    
    private func viewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    @IBAction func todayButtonDidTap(_ sender: Any) {
        selectDate(date: Date(), animated: true)
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        target?.view.endEditing(true)
    }
    
    func brCalendar(selected date: Date) {
        selectedDate = date
        delegate?.brCalendar(selected: date)
    }
    
    func brCalendar(currentMonth date: Date) {
        delegate?.brCalendar(currentMonth: date)
    }
    
}

extension BRCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateOfMonthArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BRCalendarMonthCollectionViewCell
        cell.delegate = self
        
        let dateValue = dateOfMonthArray[indexPath.row]
        cell.presentMonthButton.setTitle(brCalendar.string(for: dateValue, type: .month), for: .normal)
        cell.currentMonth = dateValue
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willIndexPath = indexPath.row
    }
    
    func collectionView(_   collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentIndexPath = indexPath.row
        guard !(willIndexPath == currentIndexPath) else { return }
        
        if willIndexPath > currentIndexPath {
            if ((dateOfMonthArray.endIndex - 1) - currentIndexPath) <= 3 {
                let value = brCalendar.date(byAdding: .month, value: 1, to: dateOfMonthArray.last!)
                dateOfMonthArray.append(value)
                let customIndexPath = IndexPath(row: dateOfMonthArray.endIndex - 1, section: 0)
                collectionView.insertItems(at: [customIndexPath])
            }
        }
        else if willIndexPath < currentIndexPath {
            if currentIndexPath <= 3 {
                let value = brCalendar.date(byAdding: .month, value: -1, to: dateOfMonthArray.first!)
                dateOfMonthArray.insert(value, at: 0)
                UIView.performWithoutAnimation {
                    collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                }
                collectionView.scrollToItem(at: IndexPath(row: self.currentIndexPath, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }

}

extension BRCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
