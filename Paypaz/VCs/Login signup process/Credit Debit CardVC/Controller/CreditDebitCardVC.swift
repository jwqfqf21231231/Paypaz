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
class CreditDebitCardVC : CardViewController {
    
    //Drop Down
    var banks = [String]()
    var bankID_Names = [String:String]()
    var selected:String?
    var isClicked : Bool?
    var fromSettings : Bool?
    //Date Picker
    var picker = MonthYearPickerView()
    var fromPin : Bool?
    var isAddingNewCard : Bool?
    private let dataSource = CreateCardDataModel()
    @IBOutlet weak var txt_cardNumber : RoundTextField!
    @IBOutlet weak var txt_expDate : RoundTextField!
    @IBOutlet weak var txt_cardHolderName : RoundTextField!
    @IBOutlet weak var txt_cvv : RoundTextField!
    @IBOutlet weak var img_CardImage : UIImageView!
    @IBOutlet weak var btn_Skip : RoundButton!
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        self.hideKeyboardWhenTappedAround()
        dataSource.delegate = self
        dataSource.delegate1 = self
        self.getBankInfo()
        // Do any additional setup after loading the view.
    }
    private func setDelegates()
    {
        txt_expDate.delegate = self
        txt_cvv.delegate = self
        txt_cardNumber.delegate = self
        txt_cardHolderName.delegate = self
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
                dataSource.bankID = selected ?? ""
                dataSource.cardNumber = txt_cardNumber.text ?? ""
                dataSource.expDate = txt_expDate.text ?? ""
                dataSource.cardHolderName = txt_cardHolderName.text ?? ""
                dataSource.cvv = txt_cvv.text ?? ""
                dataSource.createCard()
            }
        }
    }
    func validateFields() -> Bool
    {
        if txt_cardHolderName.text?.trim().count == 0
        {
            view.makeToast("Please enter holder name")
        }
        else if txt_cardNumber.text?.trim().count == 0
        {
            view.makeToast("Please enter card number")
        }
        else if (txt_cardNumber.text?.removingWhitespaceAndNewlines().count)! < 15
        {
            view.makeToast("Enter card number with 15 charecters")
        }
        else if txt_expDate.text?.trim().count == 0
        {
            view.makeToast("Please enter expiry date")
        }
        else if txt_cvv.text?.trim().count == 0
        {
            view.makeToast("Please enter cvv number")
        }
        else if isClicked == false
        {
            view.makeToast("Please select Bank")
        }
        else
        {
            return true
        }
        return false
        
    }
    @IBAction func btn_Skip(_ sender:UIButton) {
        _ = self.pushToVC("SideDrawerBaseVC")
    }
    
}
extension CreditDebitCardVC : BankInfoDataModelDelegate
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
                self.navigationController?.popViewController(animated: false)
            }
            else
            {
                _ = self.pushToVC("SideDrawerBaseVC")
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
            field.border_Color = UIColor(named: "SkyblueColor")//UIColor.red
            if textField == txt_expDate{
                txt_expDate.inputView = picker
            }
            
        }
        //  textField.layer.borderColor = UIColor.red.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            if textField == txt_expDate{
                picker.onDateSelected = { (month: Int, year: Int) in
                    self.txt_expDate.text = "\(String(format: "%02d", month))/\(String(year))" }
            }else if textField == txt_cardNumber{
                
                // MARK:- CARD NAME & CARD VALIDATER CHECK
                let card_type = CreditCardValidator(txt_cardNumber.text ?? "")
                let card_validater = CCValidator.validate(creditCardNumber: txt_cardNumber.text!)
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
                        default:
                            self.img_CardImage.image = UIImage(named: "visa")
                        }
                    }
                }else{
                    txt_cardNumber.text! = ""
                    let a = "Card is not valid"
                    self.showAlert(withMsg: a, withOKbtn: true)
                }
            }
            field.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            
            
        }
    }
}

