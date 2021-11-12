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
    var delegate : PopupDelegate?
    var banks = [String]()
    var bankID_Names = [String:String]()
    var selected:String?
    var isClicked = false
    
    
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
    
    private func getBankInfo()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getBanks()
    }
    
    func validateFields() -> Bool{
        if !isClicked
        {
            view.makeToast("Please select bank")
        }
        else if txt_AccountNumber.isEmptyOrWhitespace(){
            view.makeToast("Please enter account number")
        }
        else if txt_RoutingNumber.isEmptyOrWhitespace(){
            view.makeToast("Please enter routing number")
        }
        else if txt_EmailID.isEmptyOrWhitespace(){
            view.makeToast("Please enter email")
        }
        else if txt_PhoneNo.isEmptyOrWhitespace(){
            view.makeToast("Please enter phone number")
        }
        else if txt_AccountNumber.textCount() < 16{
            view.makeToast("Please enter card number at least 16 characters")
        }
        else if !txt_EmailID.isEmailValid(){
            view.makeToast("Please enter valid emailID")
        }
        else{
            return true
        }
        return false
    }
    
    @IBAction func btn_SelectBank(_ sender:UIButton)
    {
        sender.addDropDown(forDataSource: banks) { [weak self](item) in
            self?.selected = self?.bankID_Names[item]
            self?.isClicked = true
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.setTitle(item, for: .normal)
        }
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Submit(_ sender:UIButton) {
        if validateFields() == true
        {
            Connection.svprogressHudShow(view: self)
            dataSource.bankID = selected ?? ""
            dataSource.routingNumber = txt_RoutingNumber.text ?? ""
            dataSource.accountNumber = txt_AccountNumber.text ?? ""
            dataSource.email = txt_EmailID.text?.trim() ?? ""
            dataSource.phone = txt_PhoneNo.text?.trim() ?? ""
            dataSource.addBankAccount()
        }
    }
}
//MARK:- --- Extensions ---
extension AddBankAccountVC : AddBankAccountDataModelDelegate
{
    func didRecieveDataUpdate2(data: LogInModel)
    {
        print("CreateCardModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.delegate?.isClickedButton()
            self.navigationController?.popViewController(animated: false)
            /*if let popup = self.presentPopUpVC("BankSavedSuccessPopupVC", animated: false) as? BankSavedSuccessPopupVC {
                popup.delegate = self
            }*/
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

