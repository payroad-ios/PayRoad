//
//  DiaryEditorViewController.swift
//  PayRoad
//
//  Created by 손동찬 on 2017. 8. 18..
//  Copyright © 2017년 REFUEL. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryEditorViewController: UIViewController {
    
    let realm = try! Realm()
    
    var travel: Travel! // 여행
    var ymd: YMD! // 년-월-일
    var dayOfTravel: Int! // 여행 x번째 날
    
    var diary: Diary? // 다이어리
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "DAY \(dayOfTravel!)"
        
        dayLabel.text = "DAY \(dayOfTravel!)"
        dateLabel.text = ymd.string()
        
        if let diary = diary {
            contentTextView.text = diary.content
        } else {
            contentTextView.placeholder = "일기를 작성해주세요."
        }
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        if let diary = diary {
            // 일기 수정
            try! realm.write {
                diary.content = contentTextView.text
                diary.updatedAt = DateInRegion()
            }
        } else {
            // 일기 등록
            let diary = Diary()
            diary.ymd = ymd
            diary.content = contentTextView.text
            diary.updatedAt = DateInRegion()
            
            try! realm.write {
                travel.diaries.append(diary)
            }
        }
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}
