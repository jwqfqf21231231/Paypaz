//
//  BuyEventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class BuyEventVC : UIViewController {
    
    var typeID = ""
    var currentPage = 1
    var isFilter : String?
    var dayToSend : String?
    var distance : String?
    var dateToSend : String?
    var eventData = [MyEvent]()
    var newEventData = [MyEvent]()
    var filteredEventData = [MyEvent]()
    var newFilteredEventData = [MyEvent]()
    let dataSource = BuyEventDataModel()
    var Items = [CartInfo]()
    
    private let GetCartItemsDataSource = AddToCartDataModel()
    
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
    @IBOutlet weak var cartCountLabel : UILabel!{
        didSet{
            cartCountLabel.layer.cornerRadius = cartCountLabel.frame.height/2
            cartCountLabel.layer.masksToBounds = true
        }
    }
    var arrCalendarDays : [String]?
    var arrCalendarUTCDays : [String]?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Search.addTarget(self, action: #selector(searchEventAsPerText(_:)), for: .editingChanged)
        dataSource.delegate2 = self
        getCartItems()
        let arr = self.arrayOfDates()
        let UTCArr = self.DatesToSend()
        self.arrCalendarDays = arr as? [String] ?? []
        self.arrCalendarUTCDays = UTCArr as? [String] ?? []
        self.collectionViewCalendar.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        getEvents()
    }
    func getCartItems(){
        GetCartItemsDataSource.cartItemsDelegate = self
        GetCartItemsDataSource.getCartItems()
    }
    @objc func searchEventAsPerText(_ textField:UITextField)
    {
        if textField.isEmptyOrWhitespace(){
            print("Empty space")
        }
        else{
            dataSource.isFilter = "0"
            self.isFilter = "0"
            dataSource.search = textField.text ?? ""
            //Connection.svprogressHudShow(view: self)
            dataSource.getFilteredEvents()
        }
        
        /* self.filteredEventData.removeAll()
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
         self.tableView_Events.reloadData()*/
    }
    func getEvents()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.typeID = self.typeID
        dataSource.isFilter = self.isFilter ?? "3"
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let calendar = Calendar.current
        var offset = DateComponents()
        var dates: [Any] = [formatter.string(from: startDate).localToUTC(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd")]
        
        for i in 1..<numberOfDays {
            offset.day = i
            let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
            let nextDayString = formatter.string(from: nextDay!).localToUTC(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd")
            dates.append(nextDayString)
        }
        return dates as NSArray
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 == self.filteredEventData.count{
                if isFilter == "1"{
                    dataSource.typeID = typeID
                    dataSource.isFilter = self.isFilter ?? "1"
                    dataSource.distance = self.distance ?? ""
                    dataSource.date = self.dateToSend ?? ""
                    dataSource.pageNo = "\(currentPage)"
                    Connection.svprogressHudShow(view: self)
                    dataSource.getFilteredEvents()
                    currentPage = currentPage + 1
                }
                else if isFilter == "2"{
                    dataSource.typeID = typeID
                    dataSource.isFilter = self.isFilter ?? "1"
                    dataSource.day = self.dayToSend ?? ""
                    dataSource.pageNo = "\(currentPage)"
                    Connection.svprogressHudShow(view: self)
                    dataSource.getFilteredEvents()
                    currentPage = currentPage + 1
                }
                else if isFilter == "0"{
                    dataSource.typeID = typeID
                    dataSource.isFilter = self.isFilter ?? "0"
                    dataSource.pageNo = "\(currentPage)"
                    Connection.svprogressHudShow(view: self)
                    dataSource.getFilteredEvents()
                    currentPage = currentPage + 1
                }
                else
                {
                    dataSource.typeID = self.typeID
                    dataSource.isFilter = self.isFilter ?? "3"
                    dataSource.pageNo = "\(currentPage)"
                    Connection.svprogressHudShow(view: self)
                    dataSource.getFilteredEvents()
                    currentPage = currentPage + 1
                }
            }
        }
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
    @IBAction func btn_CartItems(_ sender:UIButton){
        _ = self.pushVC("MyCartVC")
    }
}
extension BuyEventVC : FilterData{
    func filterData(distance: String, date: String) {
        UserDefaults.standard.setDistance(value: distance)
        self.txt_Search.text?.removeAll()
        Connection.svprogressHudShow(view: self)
        dataSource.isFilter = "1"
        self.isFilter = "1"
        dataSource.distance = distance
        dataSource.date = date
        self.distance = distance
        self.dateToSend = date
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
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.view.makeToast(data.message, duration: 3, position: .bottom)
            }
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
            if currentPage-1 != 0{
                self.newEventData = data.data ?? []
                self.newFilteredEventData = data.data ?? []
                self.eventData.append(contentsOf: self.newEventData)
                self.filteredEventData.append(contentsOf: newFilteredEventData)
            }
            else{
                self.eventData = data.data ?? []
                self.filteredEventData = data.data ?? []
            }
            DispatchQueue.main.async {
                self.tableView_Events.reloadData()
            }
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                if data.message == "Data not found" && currentPage-1 >= 1{
                    print("No data at page No : \(currentPage-1)")
                    currentPage = currentPage-1
                }
                else if data.message == "Data not found" && currentPage-1 == 0{
                    self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                    self.eventData = []
                    self.filteredEventData = []
                    DispatchQueue.main.async {
                        self.tableView_Events.reloadData()
                    }
                }
                else{
                    self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                }
            }
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
extension BuyEventVC : GetCartItemsDataModelDelegate{
    func didRecieveDataUpdate(data: CartItemsModel) {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.Items = data.data ?? []
            self.cartCountLabel.alpha = 1
            self.cartCountLabel.text = "\(self.Items.count)"
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.cartCountLabel.alpha = 0
            }
        }
    }
    
    func didFailDataUpdateWithError5(error: Error) {
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
