//
//  ContactListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol ContactSelectedDelegate : class {
    func isSelectedContact(for request:Bool)
}
class ContactListVC : CustomViewController {
    
    @IBOutlet weak var tableView_Contacts : UITableView! {
        didSet {
            tableView_Contacts.dataSource = self
            tableView_Contacts.delegate   = self
        }
    }
//    @IBOutlet weak var btn_Local   : UIButton!
//    @IBOutlet weak var btn_Global  : UIButton!
//    @IBOutlet weak var view_Local  : UIView!
//    @IBOutlet weak var view_Global : UIView!
    @IBOutlet weak var view_ContactsList : UIView!
    
    var isLocalContactSelected : Bool?
    var isRequestingMoney      : Bool?
    weak var delegate : ContactSelectedDelegate?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_ContactsList.alpha = 0.0
      //  self.selectLocalPayment()
    }
    
 /*   private func selectLocalPayment() {
        self.isLocalContactSelected = true
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Local.backgroundColor  = lightBlue
        self.view_Global.backgroundColor = .clear
        self.btn_Local.setTitleColor(.white, for: .normal)
        self.btn_Global.setTitleColor(lightBlue, for: .normal)
    }
    private func selectGlobalPayment() {
        self.isLocalContactSelected = false
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Global.backgroundColor = lightBlue
        self.view_Local.backgroundColor  = .clear
        self.btn_Global.setTitleColor(.white, for: .normal)
        self.btn_Local.setTitleColor(lightBlue, for: .normal)
    }*/
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   /* @IBAction func btn_LocalPayment(_ sender:UIButton) {
        self.selectLocalPayment()
    }
    @IBAction func btn_GlobalPayment(_ sender:UIButton) {
        self.selectGlobalPayment()
    }*/
    @IBAction func btn_Scanner(_ sender:UIButton) {
        _ = self.pushToVC("QRCodeScannerVC")
    }
    @IBAction func btn_GivePermission(_ sender:UIButton) {
        self.view_ContactsList.alpha = 1.0
    }
}
