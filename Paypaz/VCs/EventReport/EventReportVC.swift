//
//  EventReportVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventReportVC : CustomViewController {
    
    
    @IBOutlet weak var view_TotalSale   : PlainCircularProgressBar!
    @IBOutlet weak var view_EventSold   : PlainCircularProgressBar!
    @IBOutlet weak var view_ProductSold : PlainCircularProgressBar!
    
    @IBOutlet weak var totalSaleLabel : UILabel!
    @IBOutlet weak var totalRegisteredLabel : UILabel!
    @IBOutlet weak var totalProductsLabel : UILabel!
    @IBOutlet weak var eventNameLabel : UILabel!
    
    @IBOutlet weak var totalSalePercent : UILabel!
    @IBOutlet weak var totalEventPercent : UILabel!
    @IBOutlet weak var totalProductPercent : UILabel!
    
    var eventInfo : [String:String]?
    private let dataSource = EventReporttDataModel()
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventNameLabel.text = eventInfo?["eventName"]
        dataSource.delegate = self
        dataSource.eventID = eventInfo?["eventID"] ?? ""
        Connection.svprogressHudShow(view: self)
        dataSource.getEventReport()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view_TotalSale.progress   = 0.0
        self.view_EventSold.progress   = 0.0
        self.view_ProductSold.progress = 0.0
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension EventReportVC : EventReportDelegate
{
    func didRecieveDataUpdate(data: EventReportModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            DispatchQueue.main.async {
                self.totalSaleLabel.text = "$\(Float(data.data?.totalSale ?? "0")?.clean ?? "0")"
                self.totalRegisteredLabel.text = data.data?.totalTicketEvent ?? "0"
                self.totalProductsLabel.text = data.data?.totalProducts ?? "0"
                let a = Float((Int(data.data?.totalEventTicketSold ?? "") ?? 0) + (Int(data.data?.totalProductQtySold ?? "") ?? 0))
                let b = Float((Int(data.data?.totalQtyProducts ?? "") ?? 0) + (Int(data.data?.totalTicketEvent ?? "") ?? 0))
                if b != 0{
                    self.totalSalePercent.text = "\(Int((a/b)*100))%"
                    self.view_TotalSale.progress = CGFloat(a/b)
                }
                else{
                    self.totalSalePercent.text = "0%"
                    self.view_TotalSale.progress = 0.0
                }
                
                let c = Float(data.data?.totalEventTicketSold ?? "") ?? 0.0
                let d = Float(data.data?.totalTicketEvent ?? "") ?? 0.0
                if d != 0{
                    self.totalEventPercent.text = "\(Int((c/d) * 100))%"
                    self.view_EventSold.progress = CGFloat(c/d)
                }
                else{
                    self.totalEventPercent.text = "0%"
                    self.view_EventSold.progress = 0.0
                }
                
                let e = Float(data.data?.totalProductQtySold ?? "") ?? 0.0
                let f = Float(data.data?.totalQtyProducts ?? "") ?? 0.0
                if f != 0{
                    self.totalProductPercent.text = "\(Int((e/f) * 100))%"
                    self.view_ProductSold.progress = CGFloat(e/f)
                }
                else{
                    self.totalProductPercent.text = "0%"
                    self.view_ProductSold.progress = 0.0
                }
            }
            
        }
        else
        {
            self.view.makeToast(data.message ?? "", duration: 3, position: .center)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
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
