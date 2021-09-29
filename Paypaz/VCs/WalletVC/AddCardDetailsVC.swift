//
//  AddCardDetailsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import CCValidator
import CreditCardValidator
class AddCardDetailsVC : CardViewController {
    
    
    var amountToAdd = ""
    //var picker = MonthYearPickerView()
    let datePicker = ShortDatePickerView()
    private let dataSource = GetWalletAmountDataModel()
    @IBOutlet weak var btn_cardNumber : RoundButton!
    @IBOutlet weak var txt_CardNumber : RoundTextField!
    @IBOutlet weak var txt_CVV : RoundTextField!
    @IBOutlet weak var txt_ExpDate : RoundTextField!
    @IBOutlet weak var txt_CardHolderName : RoundTextField!
    @IBOutlet weak var lbl_notification : UILabel!
    @IBOutlet weak var img_CardImage : UIImageView!
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedArround()
        setNotificationText()
        setDelegates()
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
        txt_ExpDate.inputAccessoryView = toolbar
        txt_ExpDate.inputView = datePicker
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        if txt_ExpDate.isFirstResponder {
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
            
            txt_ExpDate.text =  dateStr//formatter.string(from: datePicker.date)
        }
        
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    private func setNotificationText(){
        let attributedString1: NSMutableAttributedString = NSMutableAttributedString(string: "Add")
        attributedString1.setColor(color: UIColor(red: 0/255, green: 58/255, blue: 96/255, alpha: 1), forText: "Add")
        let attributedString2: NSMutableAttributedString = NSMutableAttributedString(string: " $\(amountToAdd)")
        attributedString2.setColor(color: UIColor(named: "GreenColor") ?? .green, forText: " $\(amountToAdd)")
        let attributedString3: NSMutableAttributedString = NSMutableAttributedString(string: " Money from Credit/Debit Card")
        attributedString3.setColor(color: UIColor(red: 0/255, green: 58/255, blue: 96/255, alpha: 1), forText: "Money from Credit/Debit Card")
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        lbl_notification.attributedText = attributedString1
    }
    private func setDelegates(){
        txt_ExpDate.delegate = self
        txt_CVV.delegate = self
        txt_CardNumber.delegate = self
        txt_CardHolderName.delegate = self
    }
    func validateFields() -> Bool
    {
        let getlastFour = Int(txt_ExpDate.text?.suffix(4) ?? "0") ?? 0
        if txt_CardNumber.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter card number")
        }
        else if txt_CardHolderName.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter holder name")
        }
        //        else if (txt_cardNumber.text?.removingWhitespaceAndNewlines().count)! < 15
        //        {
        //            view.makeToast("Enter card number with 15 charecters")
        //        }
        else if txt_ExpDate.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter expiry date")
        }
        else if txt_CVV.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter cvv number")
        }
        else
        {
            return true
        }
        return false
        
    }
    //MARK:- ---- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Submit(_ sender:UIButton) {
        if validateFields() == true{
            dataSource.addMoneyInWalletDelegate = self
            Connection.svprogressHudShow(view: self)
            dataSource.cardNumber = txt_CardNumber.text ?? ""
            dataSource.cvv = txt_CVV.text ?? ""
            dataSource.expDate = txt_ExpDate.text ?? ""
            dataSource.cardHolderName = txt_CardHolderName.text ?? ""
            dataSource.amount = amountToAdd
            dataSource.addMoneyToWallet()
        }
    }
    
}

extension AddCardDetailsVC : PopupDelegate {
    func isClickedButton() {
        self.navigationController?.popViewController(animated: false)
    }
}
extension AddCardDetailsVC : UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let enteredCharString = "\(textField.text ?? "")\(string )"
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == txt_CardNumber{
            let maxLegnth = 19
            if (enteredCharString.trim().count == 5){
                txt_CardNumber.insertText(" ")
            }else if (enteredCharString.trim().count == 10){
                txt_CardNumber.insertText(" ")
            }else if (enteredCharString.trim().count == 15){
                txt_CardNumber.insertText(" ")
            }
            
            
            return newString.length <= maxLegnth
            
        }else if textField == txt_CardHolderName{
            let maxLegnth = 40
            if (textField.text?.last == " " && string == " ") || (enteredCharString.trim().count == 0){
                return false
            } else {
                return newString.length <= maxLegnth
            }
        }else if textField == txt_CVV{
            let maxLegnth = 3
            if (textField.text?.last == " " && string == " ") || (enteredCharString.trim().count == 0){
                return false
            } else {
                return newString.length <= maxLegnth
            }
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            if textField == txt_CardNumber
            {
                btn_cardNumber.border_Color = UIColor(named: "SkyblueColor")
            }
            else
            {
                field.border_Color = UIColor(named: "SkyblueColor")//UIColor.red
                if textField == txt_ExpDate{
                    showDatePicker()
                    
                    // txt_ExpDate.inputView = picker
                }
            }
        }
        //  textField.layer.borderColor = UIColor.red.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            
            if textField == txt_CardNumber{
                
                if !textField.isEmptyOrWhitespace() {
                    // MARK:- CARD NAME & CARD VALIDATER CHECK
                    let card_type = CreditCardValidator(txt_CardNumber.text ?? "")
                    let card_validater = CCValidator.validate(creditCardNumber: txt_CardNumber.text!)
                    if  card_validater == true{
                        if let type = card_type.type{
                            print("Card Name : \(type)") // Visa, Mastercard, Amex etc.
                            let card_Name = type
                            switch card_Name {
                            case .visa:
                                self.img_CardImage.image = UIImage(named: "visa")
                            case .masterCard:
                                self.img_CardImage.image = UIImage(named: "master")
                            case .maestro:
                                self.img_CardImage.image = UIImage(named: "maestro")
                            case .jcb:
                                self.img_CardImage.image = UIImage(named: "jcb")
                            case .amex:
                                self.img_CardImage.image = UIImage(named: "Amex")
                            case .dinersClub:
                                self.img_CardImage.image = UIImage(named: "Dinnar")
                            case .discover:
                                self.img_CardImage.image = UIImage(named: "Discover")
                            case .unionPay:
                                self.img_CardImage.image = UIImage(named: "union")
                            case .mir:
                                self.img_CardImage.image = UIImage(named: "mir")
                            }
                        }
                    }else{
                        txt_CardNumber.text! = ""
                        let a = "Card is not valid"
                        self.showAlert(withMsg: a, withOKbtn: true)
                        
                    }
                }
                
                btn_cardNumber.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            }
//            else if textField == txt_ExpDate{
//                picker.onDateSelected = { (month: Int, year: Int) in
//                    self.txt_ExpDate.text = "\(String(format: "%02d", month))/\(String(year))" }
//                field.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
//            }
            else
            {
                field.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            }
        }
    }
}
extension AddCardDetailsVC : AddMoneyInWalletDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let popupVC = self.presentPopUpVC("MoneyAddedSuccessPopupVC", animated: true) as? MoneyAddedSuccessPopupVC {
                popupVC.amount = self.amountToAdd
                popupVC.delegate = self
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
