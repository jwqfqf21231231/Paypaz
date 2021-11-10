//
//  CreditDebitCardVC+Extensions.swift
//  Paypaz
//
//  Created by MAC on 29/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit
import CCValidator
import CreditCardValidator
/*extension CreditDebitCardVC : BankInfoDataModelDelegate
 {
 func didRecieveDataUpdate(data: BankInfoModel)
 {
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
 }*/
extension CreditDebitCardVC : CardDetailsDataModelDelegate
{
    func didRecieveDataUpdate(data: CardDetailsModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.txt_cardNumber.text = data.data?.cardNumber
            self.img_CardImage.image = UIImage(named: "\(data.data?.cardName ?? "")")
            self.txt_cardHolderName.text = data.data?.cardHolderName
            self.isPrimaryOrNot = data.data?.status ?? "0"
            self.cardName = data.data?.cardName ?? ""
            data.data?.status == "1" ? primarySwitch.setOn(true, animated: false) : primarySwitch.setOn(false, animated: false)
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
extension CreditDebitCardVC : UpdateCardDetailDataModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.addNewCardDelegate?.addNewCard()
            self.navigationController?.popViewController(animated: false)
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
extension CreditDebitCardVC : CreateCardDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.setValue(data.data?.isVerifyCard, forKey: "isVerifyCard")
            if fromSettings ?? false
            {
                self.addNewCardDelegate?.addNewCard()
                self.navigationController?.popViewController(animated: false)
            }
            else
            {
                _ = self.pushVC("SideDrawerBaseVC",animated: false)
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
extension CreditDebitCardVC : UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let enteredCharString = "\(textField.text ?? "")\(string )"
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length == 0{
            self.img_CardImage.image = UIImage(named: "card_placeHolder")
        }
        if textField == txt_cardNumber{
            let maxLegnth = 19
            if (enteredCharString.trim().count == 5){
                txt_cardNumber.insertText(" ")
            }else if (enteredCharString.trim().count == 10){
                txt_cardNumber.insertText(" ")
            }else if (enteredCharString.trim().count == 15){
                txt_cardNumber.insertText(" ")
            }
            
            
            return newString.length <= maxLegnth
            
        }else if textField == txt_cardHolderName{
            let maxLegnth = 40
            if (textField.text?.last == " " && string == " ") || (enteredCharString.trim().count == 0){
                return false
            } else {
                return newString.length <= maxLegnth
            }
        }else if textField == txt_cvv{
            if (textField.text?.last == " " && string == " ") || (enteredCharString.trim().count == 0){
                return false
            } else {
                return newString.length <= maxLength
            }
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            if textField == txt_cardNumber
            {
                btn_cardNumber.border_Color = UIColor(named: "SkyblueColor")
            }
            else
            {
                field.border_Color = UIColor(named: "SkyblueColor")
                if textField == txt_expDate{
                    showDatePicker()
                }
            }
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            
            if textField == txt_cardNumber{
                if !textField.isEmptyOrWhitespace(){
                    // MARK:- CARD NAME & CARD VALIDATER CHECK
                    let card_type = CreditCardValidator(txt_cardNumber.text ?? "")
                    let card_validater = CCValidator.validate(creditCardNumber: txt_cardNumber.text!)
                    if  card_validater == true{
                        if let type = card_type.type{
                            print("Card Name : \(type)") // Visa, Mastercard, Amex etc.
                            let card_Name = type
                            switch card_Name {
                            case .visa:
                                self.cardName = "visa"
                                self.img_CardImage.image = UIImage(named: "visa")
                            case .masterCard:
                                self.cardName = "master"
                                self.img_CardImage.image = UIImage(named: "master")
                            case .maestro:
                                self.cardName = "maestro"
                                self.img_CardImage.image = UIImage(named: "maestro")
                            case .jcb:
                                self.cardName = "jcb"
                                self.img_CardImage.image = UIImage(named: "jcb")
                            case .amex:
                                self.cardName = "Amex"
                                self.maxLength = 4
                                self.img_CardImage.image = UIImage(named: "Amex")
                            case .dinersClub:
                                self.cardName = "Dinnar"
                                self.img_CardImage.image = UIImage(named: "Dinnar")
                            case .discover:
                                self.cardName = "Discover"
                                self.img_CardImage.image = UIImage(named: "Discover")
                            case .unionPay:
                                self.cardName = "union"
                                self.img_CardImage.image = UIImage(named: "union")
                            case .mir:
                                self.cardName = "mir"
                                self.img_CardImage.image = UIImage(named: "mir")
                            }
                        }
                    }else{
                        txt_cardNumber.text! = ""
                        let a = "Card is not valid"
                        self.showAlert(withMsg: a, withOKbtn: true)
                        self.view.endEditing(true)
                    }
                }
                btn_cardNumber.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            }
            else
            {
                field.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            }
        }
    }
}

