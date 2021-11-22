//
//  SendToBankVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class SendToBankVC : CustomViewController {
    
    //MARK:- ----
    @IBOutlet weak var btn_Local      : UIButton!
    @IBOutlet weak var btn_Global     : UIButton!
    @IBOutlet weak var view_Local     : UIView!
    @IBOutlet weak var view_Global    : UIView!
    @IBOutlet weak var view_FromInfo  : UIView!
    @IBOutlet weak var view_Receiving : UIView!
    @IBOutlet weak var view_ConversionAmount : UIView!
    @IBOutlet weak var accountNumberText : UITextField!
    @IBOutlet weak var routingNumberText : UITextField!
    @IBOutlet weak var phoneNumberText : UITextField!
    @IBOutlet weak var emailIdText : UITextField!
    @IBOutlet weak var descriptionText : RoundTextView!
    @IBOutlet weak var selectBankButton : UIButton!
    private var isLocalContactSelected : Bool?
    private let dataSource = CreateCardDataModel()
    var banks = [String]()
    var bankID_Names = [String:String]()
    var selected:String?
    var isLocalClicked = false
    var isGlobalClicked = false
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate1 = self
        self.selectLocalPayment()
        getBankInfo()
    }
    
    private func getBankInfo()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getBanks()
    }
    private func selectLocalPayment() {
        self.isLocalContactSelected = true
        self.view.endEditing(true)
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Local.backgroundColor  = lightBlue
        self.view_Global.backgroundColor = .clear
        self.descriptionText.text.removeAll()
        
        self.btn_Local.setTitleColor(.white, for: .normal)
        self.btn_Global.setTitleColor(lightBlue, for: .normal)
        self.accountNumberText.text?.removeAll()
        self.routingNumberText.text?.removeAll()
        self.phoneNumberText.text?.removeAll()
        self.emailIdText.text?.removeAll()
        
        self.view_FromInfo.isHidden         = true
        self.view_Receiving.isHidden        = true
        self.view_ConversionAmount.isHidden = true
        
        if isLocalClicked == false{
            selectBankButton.setTitle("Select Bank", for: .normal)
            selectBankButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    private func selectGlobalPayment() {
        self.isLocalContactSelected = false
        self.view.endEditing(true)
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Global.backgroundColor = lightBlue
        self.view_Local.backgroundColor  = .clear
        self.descriptionText.text.removeAll()
        self.accountNumberText.text?.removeAll()
        self.routingNumberText.text?.removeAll()
        self.phoneNumberText.text?.removeAll()
        self.emailIdText.text?.removeAll()
        self.btn_Global.setTitleColor(.white, for: .normal)
        self.btn_Local.setTitleColor(lightBlue, for: .normal)
        
        self.view_FromInfo.isHidden         = false
        self.view_Receiving.isHidden        = false
        self.view_ConversionAmount.isHidden = false
        if isGlobalClicked == false{
            selectBankButton.setTitle("Select Bank", for: .normal)
            selectBankButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    @IBAction func btn_LocalPayment(_ sender:UIButton) {
        self.selectLocalPayment()
    }
    @IBAction func btn_GlobalPayment(_ sender:UIButton) {
        self.selectGlobalPayment()
    }
    
    //MARK:- ---- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
        }
    }
    
    @IBAction func btn_SelectBank(_ sender:UIButton)
    {
        if self.isLocalContactSelected ?? false{
            
            sender.addDropDown(forDataSource: banks) { [weak self](item) in
                self?.selected = self?.bankID_Names[item]
                self?.isLocalClicked = true
                sender.setTitleColor(UIColor(named: "Blue Color"), for: .normal)
                sender.setTitle(item, for: .normal)
            }
        }
        else{
            
            sender.addDropDown(forDataSource: banks) { [weak self](item) in
                self?.selected = self?.bankID_Names[item]
                self?.isGlobalClicked = true
                sender.setTitleColor(UIColor(named: "Blue Color"), for: .normal)
                sender.setTitle(item, for: .normal)
            }
        }
    }
    
    @IBAction func btn_Send(_ sender:UIButton) {
        if self.isLocalContactSelected ?? false {
            if validateFields() == true{
                self.view.makeToast("Functionality not implemented yet")
                /* if let popupVC = self.presentPopUpVC("MoneyAddedSuccessPopupVC", animated: true) as? MoneyAddedSuccessPopupVC {
                 // popupVC.delegate = self
                 popupVC.selectedMoneyType = .MoneySentSuccess
                 }*/
            }
        }
        else {
            if let vc = self.pushVC("EnterPinVC") as? EnterPinVC{
                vc.delegate = self
            }
            /*if let passcodeVC = self.pushVC("PasscodeVC") as? PasscodeVC {
             passcodeVC.delegate = self
             passcodeVC.isNavigatedFromPaymentVC = true
             }*/
        }
        
    }
    func validateFields() -> Bool{
        view.endEditing(true)
        if !isLocalClicked
        {
            self.view.makeToast("Please select bank")
        }
        else if accountNumberText.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter bank account number.")
        }
        else if routingNumberText.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter bank routing number.")
        }
        else if phoneNumberText.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter mobile number.")
        }
        else if emailIdText.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter email id.")
        }
        else if accountNumberText.text?.count ?? 0 < 11{
            view.makeToast("Please enter card number at least 11 characters")
        }
        else if !emailIdText.isEmailValid(){
            view.makeToast("Please enter valid emailID")
        }
        else{
            return true
        }
        return false
    }
}
extension SendToBankVC : SendBackPinCodeDelegate{
    func sendBackPinCode(pin : String){
        self.view.makeToast("Functionality not implemented")
    }
}
extension SendToBankVC : PopupDelegate {
    func isClickedButton() {
        if self.isLocalContactSelected ?? false { } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                if let popupVC = self?.presentPopUpVC("MoneyAddedSuccessPopupVC", animated: true) as? MoneyAddedSuccessPopupVC {
                    // popupVC.delegate = self
                    popupVC.selectedMoneyType = .MoneySentSuccess
                }
            }
        }
        
        
    }
}
extension SendToBankVC : BankInfoDataModelDelegate
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
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.unauthorized = true
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
