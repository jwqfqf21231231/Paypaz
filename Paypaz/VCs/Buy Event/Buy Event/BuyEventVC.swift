//
//  BuyEventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class BuyEventVC : CustomViewController {
    
    var typeID = ""
    var eventData = [MyEvent]()
    var filteredEventData = [MyEvent]()
    let dataSource = BuyEventDataModel()
    var index = 0
    @IBOutlet weak var txt_Search : UITextField!
    
    @IBOutlet weak var tableView_Events : UITableView! {
        didSet {
            tableView_Events.dataSource = self
            tableView_Events.delegate   = self
        }
    }
    @IBOutlet weak var collectionViewCalendar : UICollectionView! {
        didSet {
            collectionViewCalendar.allowsSelection = true
            collectionViewCalendar.dataSource = self
            collectionViewCalendar.delegate   = self
        }
    }
    
    var arrCalendarDays : [String]?
    var arrCalendarUTCDays : [String]?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Search.addTarget(self, action: #selector(searchEventAsPerText(_:)), for: .editingChanged)
        dataSource.delegate2 = self
        let arr = self.arrayOfDates()
        let UTCArr = self.DatesToSend()
        self.arrCalendarDays = arr as? [String] ?? []
        self.arrCalendarUTCDays = UTCArr as? [String] ?? []
        self.collectionViewCalendar.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        getEvents()
    }
    @objc func searchEventAsPerText(_ textField:UITextField)
    {
        self.filteredEventData.removeAll()
        if textField.text?.count != 0 {
            for eventData in self.eventData {
                let isMatchingEventName : NSString = eventData.name! as NSString
                let range = isMatchingEventName.lowercased.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filteredEventData.append(eventData)
                }
            }
        } else {
            self.filteredEventData = self.eventData
        }
        self.tableView_Events.reloadData()
    }
    func getEvents()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.typeID = self.typeID
        dataSource.isFilter = "2"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm a"
        let currentDate = dateformatter.string(from: Date())
        dataSource.day = currentDate.localToUTC(incomingFormat: "yyyy-MM-dd HH:mm a", outGoingFormat: "yyyy-MM-dd")
        dataSource.pageNo = "0"
        dataSource.getFilteredEvents()
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
    func DatesToSend() -> NSArray {
        let numberOfDays: Int = 30
        let startDate = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm a"
        let calendar = Calendar.current
        var offset = DateComponents()
        var dates: [Any] = [formatter.string(from: startDate).localToUTC(incomingFormat: "yyyy-MM-dd HH:mm a", outGoingFormat: "yyyy-MM-dd")]
        
        for i in 1..<numberOfDays {
            offset.day = i
            let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
            let nextDayString = formatter.string(from: nextDay!).localToUTC(incomingFormat: "yyyy-MM-dd HH:mm a", outGoingFormat: "yyyy-MM-dd")
            dates.append(nextDayString)
        }
        return dates as NSArray
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Filter(_ sender:UIButton) {
        if let vc = self.presentPopUpVC("FilterVC", animated: true) as? FilterVC{
            vc.delegate = self
        }
    }
    
}
extension BuyEventVC : FilterData{
    func filterData(distance: String, date: String) {
        Connection.svprogressHudShow(view: self)
        dataSource.isFilter = "1"
        dataSource.distance = distance
        dataSource.date = date
        dataSource.typeID = typeID
        dataSource.getFilteredEvents()
    }
}
extension BuyEventVC : FavEventDataModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        print("EventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.view.makeToast(data.message, duration: 3, position: .bottom)
        }
        else
        {
            self.view.makeToast(data.message, duration: 3, position: .bottom)
            // self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError1(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
extension BuyEventVC : FilteredEventDataModelDelegate
{
    func didRecieveDataUpdate1(data: MyEventsListModel)
    {
        print("FilteredEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.eventData = data.data ?? []
            self.filteredEventData = data.data ?? []
            DispatchQueue.main.async {
                self.tableView_Events.reloadData()
            }
        }
        else
        {
            if data.message == "Data not found"{
                self.eventData.removeAll()
                self.filteredEventData.removeAll()
                self.tableView_Events.reloadData()
            }
            self.view.makeToast(data.message, duration: 0.5, position: .bottom)
            // self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError2(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
