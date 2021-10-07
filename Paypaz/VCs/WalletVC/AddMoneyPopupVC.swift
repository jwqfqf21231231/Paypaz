//
//  AddMoneyPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol AddMoneyPopupDelegate : class {
    func loadWallet()
}
protocol PaymentSuccessfulDelegate : class{
    func goBackToVC()
}
//protocol BuyEventThruCardDelegate : class{
//    func buyEventThruCard(cvv:String,)
//}
class AddMoneyPopupVC  : UIViewController {
    
    weak var delegate : AddMoneyPopupDelegate?
    weak var successDelegate : PaymentSuccessfulDelegate?
    var cartInfo : UpdatedCartInfo?
    //var selectedType  : AddMoneyType?
    var maxLength = 3
    var cardID = ""
    var existingCards = [CardsList](){
        didSet{
            tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
            tableView_AddCards.reloadData()
            tableView_AddCards.layoutIfNeeded()
            self.tableViewHeight.constant = self.tableView_AddCards.contentSize.height
        }
    }
    @IBOutlet weak var tableViewHeight : NSLayoutConstraint!
    @IBOutlet weak var txt_AmountToAdd : UITextField!
    @IBOutlet weak var mainViewHeight : NSLayoutConstraint!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var txt_CVV : UITextField!{
        didSet{
            txt_CVV.delegate = self
        }
    }
    @IBOutlet weak var tableView_AddCards       : UITableView!{
        didSet{
            tableView_AddCards.separatorStyle = .none
            tableView_AddCards.dataSource = self
            tableView_AddCards.delegate   = self
        }
    }
    private let walletDataSource = GetWalletAmountDataModel()
    public let dataSource = CreateCardDataModel()
    let paymentDataSource = PaymentDataModel()
    var buyTicket : Bool?
    var totalAmount : Int?
    //    @IBOutlet weak var btn_BankAcc     : RoundButton!
    //    @IBOutlet weak var btn_DebitCredit : RoundButton!
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentDataSource.delegate = self
        walletDataSource.addMoneyInWalletDelegate = self
        dataSource.cardListDelegate = self
        //self.selectedType = .BankAccount
        getCardsList()
        if buyTicket ?? false{
            self.txt_AmountToAdd.isUserInteractionEnabled = false
            self.txt_AmountToAdd.text = "\(totalAmount ?? 0)"
            self.submitButton.setTitle("Continue", for: .normal)
        }
    }
    func getCardsList(){
        Connection.svprogressHudShow(view: self)
        dataSource.getCardsList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Cancel(_ sender:UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btn_AddMoney(_ sender:UIButton) {
        let amount = (txt_AmountToAdd.text! as NSString).integerValue
        if !(amount > 0){
            self.view.makeToast("The amount must be greater than 0")
        }
        else if txt_AmountToAdd.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter amount to add in wallet")
        }
        else if txt_CVV.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter your card cvv")
        }
        else{
            Connection.svprogressHudShow(view: self)
            if buyTicket ?? false{
                paymentDataSource.eventID = cartInfo?.eventID ?? ""
                paymentDataSource.eventUserID = cartInfo?.eventUserID ?? ""
                paymentDataSource.eventQty = cartInfo?.eventQty ?? ""
                paymentDataSource.eventPrice = cartInfo?.eventPrice ?? ""
                paymentDataSource.productsPrice = cartInfo?.productsPrice ?? ""
                paymentDataSource.subTotal = cartInfo?.subTotal ?? ""
                paymentDataSource.discount = cartInfo?.discount ?? ""
                paymentDataSource.tax = cartInfo?.tax ?? ""
                paymentDataSource.grandTotal = cartInfo?.grandTotal ?? ""
                paymentDataSource.cartID = cartInfo?.cartID ?? ""
                paymentDataSource.cardID = cardID
                paymentDataSource.cvv = txt_CVV.text ?? ""
//                let jsonData = try! JSONSerialization.data(withJSONObject:cartInfo?.products ?? [])
//                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
//                print(jsonString!)
//                paymentDataSource.products = jsonString ?? ""
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try! encoder.encode(cartInfo?.products)
                paymentDataSource.products = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? ""
                paymentDataSource.paymentType = cartInfo?.paymentType ?? ""
                paymentDataSource.paymentMethod = "3"
                paymentDataSource.requestPayment()
            }
            else{
                walletDataSource.isCard = "0"
                walletDataSource.cardID = cardID
                walletDataSource.cvv = txt_CVV.text ?? ""
                walletDataSource.amount = txt_AmountToAdd.text ?? ""
                walletDataSource.addMoneyToWallet()
            }
        }
    }
    /* @IBAction func btn_BankAccount(_ sender:UIButton) {
     self.selectedType = .BankAccount
     let green = UIColor(red: 0.89, green: 0.97, blue: 0.93, alpha: 1.00)
     self.btn_DebitCredit.backgroundColor = UIColor.white
     self.btn_DebitCredit.setTitleColor(.lightGray, for: .normal)
     self.btn_BankAcc.backgroundColor = green
     self.btn_BankAcc.setTitleColor(UIColor(named: "GreenColor"), for: .normal)
     }
     @IBAction func btn_DebitCreditCard(_ sender:UIButton) {
     self.selectedType = .DebitCreditCard
     let green = UIColor(red: 0.89, green: 0.97, blue: 0.93, alpha: 1.00)
     self.btn_BankAcc.backgroundColor = UIColor.white
     self.btn_BankAcc.setTitleColor(.lightGray, for: .normal)
     self.btn_DebitCredit.backgroundColor = green
     self.btn_DebitCredit.setTitleColor(UIColor(named: "GreenColor"), for: .normal)
     }*/
}
extension AddMoneyPopupVC : PaymentDelegate
{
    func didRecieveDataUpdate1(data: Basic_Model)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.dismiss(animated: false) {
                self.successDelegate?.goBackToVC()
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            //view.makeToast(data.message ?? "")
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

extension AddMoneyPopupVC : AddMoneyInWalletDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.delegate?.loadWallet()
            self.dismiss(animated: false, completion: nil)
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

extension AddMoneyPopupVC : UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let enteredCharString = "\(textField.text ?? "")\(string )"
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if textField == txt_CVV{
            if (textField.text?.last == " " && string == " ") || (enteredCharString.trim().count == 0){
                return false
            } else {
                return newString.length <= maxLength
            }
        }
        return true
    }
}

extension AddMoneyPopupVC : GetCardsListDataModelDelegate
{
    func didRecieveDataUpdate(data: CardsListModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.existingCards = data.data ?? []
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
extension AddMoneyPopupVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as? CardCell else { return UITableViewCell() }
        cell.cardImage.image = UIImage(named: "\(existingCards[indexPath.row].cardName ?? "")")
        var cardNumber = existingCards[indexPath.row].cardNumber ?? ""
        let firstIndex = cardNumber.index(cardNumber.startIndex, offsetBy: 12)
        if cardNumber.count < 19{
            cardNumber.replaceSubrange((firstIndex...),with: "XX XXX")
        }
        else{
            cardNumber.replaceSubrange((firstIndex...),with: "XX XXXX")
        }
        if existingCards[indexPath.row].status == "1"{
            cell.deleteButton.setImage(UIImage(named:"paid"), for: .normal)
            cell.innerBackgroundView.backgroundColor = UIColor(red: 22/255, green: 195/255, blue: 97/255, alpha: 0.1)
            self.cardID = existingCards[indexPath.row].id ?? ""
            if existingCards[indexPath.row].cardName == "Amex"{
                self.maxLength = 4
            }
        }
        else{
            cell.deleteButton.setImage(nil, for: .normal)
        }
        cell.cardNumberLabel.text = cardNumber
        cell.carHolderNameLabel.text = existingCards[indexPath.row].cardHolderName

        let tapGesture = CustomTapGestureRecognizer(target: self,
                                                    action: #selector(tapSelector(sender:)))
        tapGesture.viewIndex = indexPath.row
        cell.innerBackgroundView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func tapSelector(sender: CustomTapGestureRecognizer) {
        let index = sender.viewIndex ?? 0
        self.cardID = existingCards[index].id ?? ""
        if existingCards[index].cardName == "Amex"{
            self.maxLength = 4
        }
        for i in 0..<existingCards.count{
            let indexPath = IndexPath.init(row: i, section: 0)
            if let cell = tableView_AddCards.cellForRow(at: indexPath) as? CardCell{
                cell.deleteButton.setImage(nil, for: .normal)
                cell.innerBackgroundView.backgroundColor = UIColor(red: 232/255, green: 238/255, blue: 255/255, alpha: 1)
            }
        }
        let indexpath = IndexPath.init(row: index, section: 0)
        if let cell = tableView_AddCards.cellForRow(at: indexpath) as? CardCell{
            cell.deleteButton.setImage(UIImage(named: "paid"), for: .normal)
            cell.innerBackgroundView.backgroundColor = UIColor(red: 22/255, green: 195/255, blue: 97/255, alpha: 0.1)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
