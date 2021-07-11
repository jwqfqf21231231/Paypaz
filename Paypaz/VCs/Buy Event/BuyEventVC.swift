//
//  BuyEventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class BuyEventVC : CustomViewController {
    @IBOutlet weak var tableView_Events : UITableView! {
           didSet {
               tableView_Events.dataSource = self
               tableView_Events.delegate   = self
           }
       }
    @IBOutlet weak var collectionViewCalendar : UICollectionView! {
        didSet {
            collectionViewCalendar.dataSource = self
            collectionViewCalendar.delegate   = self
        }
    }
    
    var arrCalendarDays : [String]?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = self.arrayOfDates()
        self.arrCalendarDays = arr as? [String] ?? []
        self.collectionViewCalendar.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
    }
    func arrayOfDates() -> NSArray {
            
            let numberOfDays: Int = 30
            let startDate = Date()
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "EEE d"
            let calendar = Calendar.current
            var offset = DateComponents()
            var dates: [Any] = [formatter.string(from: startDate)]
            
            for i in 1..<numberOfDays {
                offset.day = i
                let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
                let nextDayString = formatter.string(from: nextDay!)
                dates.append(nextDayString)
            }
            return dates as NSArray
        }
    
    
    // MARK: - --- Action ----
        @IBAction func btn_back(_ sender:UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
    @IBAction func btn_Filter(_ sender:UIButton) {
        _ = self.presentPopUpVC("FilterVC", animated: true)
    }
   
}
