//
//  DiaryTableViewController.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate(set) var travel: Travel!
    fileprivate(set) var travelPeriodDates = [YMD]()
    fileprivate(set) var diaryDictionary = [YMD: Diary]()
    
    fileprivate(set) var diaryNotificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        extractDatePeriod()
        initDataStructures()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        diaryNotificationToken = travel.diaries.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.initDataStructures()
            self?.tableView.reloadData()
        }
    }
    
    func extractDatePeriod() {
        let startYMD = travel.startDateInRegion!.ymd
        let endYMD = travel.endDateInRegion!.ymd
        let dates = DateUtil.generateYMDPeriod(from: startYMD, to: endYMD)
        travelPeriodDates = dates
    }
    
    func initDataStructures() {
        for diary in travel.diaries {
            diaryDictionary[diary.ymd] = diary
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDiary" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let diaryEditorViewController = segue.destination as! DiaryEditorViewController
                let ymd = travelPeriodDates[indexPath.row]
                diaryEditorViewController.set(travel: travel)
                diaryEditorViewController.set(ymd: ymd)
                diaryEditorViewController.set(dayOfTravel: indexPath.row + 1)
                if let diary = diaryDictionary[ymd] {
                    diaryEditorViewController.set(diary: diary)
                }
            }
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DiaryTableViewController {
    func set(travel: Travel) {
        self.travel = travel
    }
}

extension DiaryTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelPeriodDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryTableViewCell
        
        let ymd = travelPeriodDates[indexPath.row]
        cell.dayLabel.text = "DAY \(indexPath.row + 1)"
        cell.dateLabel.text = ymd.string()
        
        if let diary = diaryDictionary[ymd] {
            cell.contentLabel.textColor = UIColor.black
            cell.contentLabel.text = diary.content
        } else {
            cell.contentLabel.textColor = UIColor.lightGray
            cell.contentLabel.text = "일기를 작성해주세요."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
