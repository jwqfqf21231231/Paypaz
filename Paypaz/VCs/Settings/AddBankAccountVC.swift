//
//  AddBankAccountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class AddBankAccountVC : CardViewController {
    
    //Drop Down - Properties
    var banks = [String]()
    var bankID_Names = [String:String]()
    var selected:String?
    var isClicked : Bool?

    
    @IBOutlet weak var txt_AccountNumber : UITextField!
    @IBOutlet weak var txt_RoutingNumber : UITextField!
    @IBOutlet weak var txt_EmailID : UITextField!
    @IBOutlet weak var txt_PhoneNo : UITextField!
    private let dataSource = CreateCardDataModel()

    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate1 = self
        dataSource.delegate2 = self
        self.hideKeyboardWhenTappedArround()
        getBankInfo()
    }
    @IBAction func btn_SelectBank(_ sender:UIButton)
    {
        isClicked = true
        sender.addDropDown(forDataSource: banks) { [weak self](item) in
            self?.selected = self?.bankID_Names[item]
            if let btn = self?.view.viewWithTag(101) as? UIButton{
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitle(item, for: .normal)
            }
            
        }
    }
    
    private func getBankInfo()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getBanks()
    }
    // MARK: - --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        guard !(txt_AccountNumber.text?.isEmpty)! && !(txt_AccountNumber.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            
            showAlert(withMsg: "Please enter card name.", withOKbtn: true)
            return
        }
        guard !(txt_RoutingNumber.text?.isEmpty)! && !(txt_RoutingNumber.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            showAlert(withMsg: "Please enter routing number.", withOKbtn: true)
            return
        }
        guard !((txt_AccountNumber.text?.count)! < 11) else {
            showAlert(withMsg: "Please enter card number at least 11 charecters", withOKbtn: true)
            return
        }
        guard !(txt_EmailID.text?.isEmpty)! && !(txt_EmailID.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            showAlert(withMsg: "Please enter your Email.", withOKbtn: true)
            return
        }
        guard !(txt_EmailID.text?.trim().count == 0) else {
            showAlert(withMsg: "Please enter valid Email.", withOKbtn: true)
            return
        }
        guard !(txt_PhoneNo.text?.isEmpty)! && !(txt_PhoneNo.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            showAlert(withMsg: "Please enter your Phone number.", withOKbtn: true)
            return
        }
        if isClicked == false
        {
            showAlert(withMsg: "Please select Bank", withOKbtn: true)
            return
        }
        Connection.svprogressHudShow(view: self)
        dataSource.bankID = selected ?? ""
        dataSource.routingNumber = txt_RoutingNumber.text ?? ""
        dataSource.accountNumber = txt_AccountNumber.text ?? ""
        dataSource.email = txt_EmailID.text ?? ""
        dataSource.phone = txt_PhoneNo.text ?? ""
        dataSource.addBankAccount()
    }
}
//MARK:-
extension AddBankAccountVC : AddBankAccountDataModelDelegate
{
    func didRecieveDataUpdate2(data: ResendOTPModel)
    {
        print("CreateCardModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let popup = self.presentPopUpVC("BankSavedSuccessPopupVC", animated: false) as? BankSavedSuccessPopupVC {
                popup.delegate = self
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
extension AddBankAccountVC : BankInfoDataModelDelegate
{
    func didRecieveDataUpdate(data: BankInfoModel)
    {
        print("BankInfoModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let banks = data.data ?? []
            for i in 0..<banks.count
            {
                self.banks.append(banks[i].bankName ?? "")
                self.bankID_Names[banks[i].bankName ?? ""] = banks[i].id ?? ""
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
extension AddBankAccountVC : PopupDelegate {
    
    func isClickedButton() {
        self.navigationController?.popViewController(animated: false)
    }
}

