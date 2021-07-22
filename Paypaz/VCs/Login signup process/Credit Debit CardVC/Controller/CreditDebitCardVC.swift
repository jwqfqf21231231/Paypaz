//
//  CreditDebitCardVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class CreditDebitCardVC : CustomViewController {
    
    //Drop Down
    var banks = [String]()
    var bankID_Names = [String:String]()
    var selected:String?
    
    //Date Picker
    var datePicker:UIDatePicker!
    
    
    var isAddingNewCard : Bool?
    var isClicked : Bool?
    private let dataSource = CreateCardDataModel()
    @IBOutlet weak var txt_cardNumber : RoundTextField!
    @IBOutlet weak var txt_expDate : RoundTextField!
    @IBOutlet weak var txt_cardHolderName : RoundTextField!
    @IBOutlet weak var txt_cvv : RoundTextField!
    @IBOutlet weak var btn_Skip : RoundButton!
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        dataSource.delegate = self
        dataSource.delegate1 = self
        self.getBankInfo()
        txt_expDate.addTarget(self, action: #selector(giveExpDate), for: .editingDidBegin)
        // Do any additional setup after loading the view.
    }
    private func getBankInfo()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getBanks()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAddingNewCard ?? false {
            self.btn_Skip.alpha = 0.0
        }
    }
    @objc func donePressed()
    {
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MM/yyyy"
        self.txt_expDate.text=dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func createToolBar()->UIToolbar
    {
        //tool bar
        let toolBar=UIToolbar()
        toolBar.sizeToFit()
        //bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: true)
        return toolBar
    }
    func createDatePicker()
    {
        datePicker=UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        txt_expDate.inputView=datePicker
        txt_expDate.inputAccessoryView=createToolBar()
    }
    @objc func giveExpDate()
    {
        createDatePicker()
    }
    
    
    
    // MARK: - --- Action ----
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
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_VerifyCard(_ sender:UIButton) {
        if isAddingNewCard ?? false {
            self.navigationController?.popViewController(animated: true)
        } else {
            if isClicked == false
            {
                self.showAlert(withMsg: "Please select Bank", withOKbtn: true)
            }
            else if txt_cardNumber == nil
            {
                self.showAlert(withMsg: "Please Enter Card Number", withOKbtn: true)
            }
            else if txt_expDate == nil
            {
                self.showAlert(withMsg: "Please Enter Exp Date", withOKbtn: true)
            }
            else if txt_cardHolderName == nil
            {
                self.showAlert(withMsg: "Please Enter Card Holder Name", withOKbtn: true)
            }
            else if txt_cvv == nil
            {
                self.showAlert(withMsg: "Please Enter CVV", withOKbtn: true)
            }
            else
            {
                Connection.svprogressHudShow(view: self)
                dataSource.bankID = selected ?? ""
                dataSource.cardNumber = txt_cardNumber.text ?? ""
                dataSource.expDate = txt_expDate.text ?? ""
                dataSource.cardHolderName = txt_cardHolderName.text ?? ""
                dataSource.cvv = txt_cvv.text ?? ""
                dataSource.createCard()
            }
        }
    }
    
    @IBAction func btn_Skip(_ sender:UIButton) {
        _ = self.pushToVC("SideDrawerBaseVC")
    }
    
}
extension CreditDebitCardVC : BankInfoDataModelDelegate
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
extension CreditDebitCardVC : CreateCardDataModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        print("CreateCardModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            _ = self.pushToVC("SideDrawerBaseVC")
            
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
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
