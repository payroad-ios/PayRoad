//
//  BRCalendarMonthCollectionViewCell.swift
//  PayRoad_CalendarPractice
//
//  Created by Febrix on 2017. 8. 12..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit

protocol BRCalendarDelegate {
    func brCalendar(selected date: Date)
    func brCalendar(currentMonth month: Date)
}

class BRCalendarMonthCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var presentMonthButton: UIButton!
    
    let cellId = "dayCell"
    var delegate: BRCalendarDelegate?
    let brCalendar = BRCalendarFormatter()
    var dayOfMonthDate = [Date]()
    var currentMonth: Date? {
        didSet {
            generateData()
            delegate?.brCalendar(currentMonth: currentMonth!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "BRCalendarDayCollectionViewCell", bundle: nil)
        daysCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.allowsMultipleSelection = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayOfMonthDate = [Date]()
    }
    
    func generateData() {
        let dayOfMonthDateArray = brCalendar.compositionDayOfMonth(month: currentMonth!)
        dayOfMonthDate = dayOfMonthDateArray
        daysCollectionView.reloadData()
    }
    
    func selectDay(date: Date, animated: Bool) {
        let index = dayOfMonthDate.index(of: date)
        let indexPath = IndexPath(row: index!, section: 0)
        
        for selectedIndexPath in daysCollectionView.indexPathsForSelectedItems! {
            daysCollectionView.deselectItem(at: selectedIndexPath, animated: false)
        }
        delegate?.brCalendar(selected: dayOfMonthDate[indexPath.row])
        daysCollectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
    }
}


extension BRCalendarMonthCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BRCalendarDayCollectionViewCell
        
        let date = dayOfMonthDate[indexPath.row]
        cell.dayLabel.text = brCalendar.string(for: date, type: .day)
        
        let isEqualMonth = brCalendar.compareRangeOfDate(compareType: .month, base: currentMonth!, compare: date)
        cell.indicatorNotEqualCurrentMonth(bool: isEqualMonth)
        
        let isToday = brCalendar.compareRangeOfDate(compareType: .day, base: date, compare: Date())
        cell.indicatorToday(bool: isToday)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayOfMonthDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.brCalendar(selected: dayOfMonthDate[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension BRCalendarMonthCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 7) - 1
        let height = (collectionView.frame.height / 6) - 1
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
