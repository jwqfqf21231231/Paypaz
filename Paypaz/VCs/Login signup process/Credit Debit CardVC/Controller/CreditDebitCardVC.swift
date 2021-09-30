//
//  CreditDebitCardVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import CCValidator
import CreditCardValidator
protocol AddNewCardDelegate : class{
    func addNewCard()
}
class CreditDebitCardVC : CardViewController {
    
    //Drop Down
    var banks = [String]()
    var bankID_Names = [String:String]()
    var selected:String?
    var isClicked : Bool?
    var fromSettings : Bool?
    var cardName = ""
    var isPrimaryOrNot = "0"
    var cardID = ""
    var maxLength = 3
    var strictlyPrimary : Bool?
    var madePrimary : Bool?
    //Date Picker
    //var picker = MonthYearPickerView()
    let datePicker = ShortDatePickerView()
    weak var addNewCardDelegate : AddNewCardDelegate?
    var fromPin : Bool?
    var isAddingNewCard : Bool?
    private let dataSource = CreateCardDataModel()
    @IBOutlet weak var btn_cardNumber : RoundButton!
    @IBOutlet weak var txt_cardNumber : RoundTextField!
    @IBOutlet weak var txt_expDate : RoundTextField!
    @IBOutlet weak var txt_cardHolderName : RoundTextField!
    @IBOutlet weak var txt_cvv : RoundTextField!
    @IBOutlet weak var img_CardImage : UIImageView!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var primarySwitch : UISwitch!
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        self.hideKeyboardWhenTappedArround()
        if strictlyPrimary ?? false{
            self.primarySwitch.setOn(true, animated: false)
            self.primarySwitch.isUserInteractionEnabled = false
            self.isPrimaryOrNot = "1"
        }
        if cardID != ""{
            self.lbl_Title.text = "Edit Card Details"
            dataSource.cardID = self.cardID
            Connection.svprogressHudShow(view: self)
            dataSource.getCardDetails()
        }
        primarySwitch.addTarget(self, action: #selector(isPrimaryOrNot(_:)), for: .valueChanged)
        //    self.getBankInfo()
        // Do any additional setup after loading the view.
    }
    @objc func isPrimaryOrNot(_ sender:UISwitch){
        sender.isOn == true ? (isPrimaryOrNot = "1") : (isPrimaryOrNot = "0")
    }
    func showDatePicker(){
        //Formate Date
        //  datePicker.datePickerMode = .date//.date
        // datePicker.minimumDate = Date()
        
        
        //        datePicker.minYear = 2021
        //        datePicker.maxYear = 2090
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem()
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        txt_expDate.inputAccessoryView = toolbar
        txt_expDate.inputView = datePicker
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        if txt_expDate.isFirstResponder {
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            let dateformatter = DateFormatter()
            //  let date = Date()
            dateformatter.dateFormat = "MM/yyyy"//"MM-dd-yyyy"
            let dateStr = dateformatter.string(from: datePicker.date)
            print(dateStr)
            
            //if datePicker.select
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let dateString = formatter.string(from: Date())
            
            let getlastYear = dateStr.suffix(4).description
            let getMonthStr = dateStr.prefix(2).description
            
            var monthString = String()
            
            
            if getlastYear == dateString{
                
                let formatterN = DateFormatter()
                formatterN.dateFormat = "MM"
                monthString = formatterN.string(from: Date())
                
                if Int(getMonthStr) ?? 0 < Int(monthString) ?? 0{
                    self.showAlert(withMsg: "Please select valid date", withOKbtn: true)
                    //self.showAlert(message: "Please select valid date", title: "Fuel")
                    return
                }
            }
            
            txt_expDate.text =  dateStr//formatter.string(from: datePicker.date)
        }
        
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    private func setDelegates()
    {
        txt_expDate.delegate = self
        txt_cvv.delegate = self
        txt_cardNumber.delegate = self
        txt_cardHolderName.delegate = self
        dataSource.delegate = self
        dataSource.cardDetailsDelegate = self
        dataSource.updateCardDetailsDelegate = self
        //dataSource.delegate1 = self
    }
    private func getBankInfo()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getBanks()
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
        if fromPin ?? false
        {
            self.showAlert(withMsg: "You have already entered Pin", withOKbtn: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btn_VerifyCard(_ sender:UIButton) {
        if isAddingNewCard ?? false {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            if validateFields() == true
            {
                Connection.svprogressHudShow(view: self)
                dataSource.cardNumber = txt_cardNumber.text ?? ""
                dataSource.expDate = txt_expDate.text ?? ""
                dataSource.cardHolderName = txt_cardHolderName.text ?? ""
                dataSource.cvv = txt_cvv.text ?? ""
                dataSource.status = isPrimaryOrNot
                dataSource.cardName = cardName
                if cardID != ""{
                    dataSource.cardID = self.cardID
                    dataSource.updateCard()
                }
                else{
                    dataSource.createCard()
                }
            }
        }
    }
    func validateFields() -> Bool
    {
        if txt_cardHolderName.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter holder name")
        }
        else if txt_cardNumber.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter card number")
        }
        
        else if txt_expDate.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter expiry date")
        }
        else if txt_cvv.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter cvv number")
        }
        else if maxLength != txt_cvv.text?.count
        {
            view.makeToast("Please enter valid cvv")
        }
        else if self.madePrimary ?? false == true  && isPrimaryOrNot == "0"{
            view.makeToast("Please set another card as primary before make this card as secondary")
        }
        else
        {
            return true
        }
        return false
    }
}
