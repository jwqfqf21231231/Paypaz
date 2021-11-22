//
//  PaymentCardsVC+Extensions.swift
//  Paypaz
//
//  Created by MAC on 29/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//
import UIKit
extension PaymentCardsVC : GetCardsListDataModelDelegate
{
    func didRecieveDataUpdate(data: CardsListModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.existingCards = data.data ?? []
            if data.data == nil{
                UserDefaults.standard.setValue("0", forKey: "isVerifyCard")
            }
        }
        else
        {
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if  data.isSuspended == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            }
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
extension PaymentCardsVC : AddNewCardDelegate{
    func addNewCard() {
        self.getCardsList()
    }
}
extension PaymentCardsVC : DeleteCardDataModelDelegate
{
    func didRecieveDataUpdate(data: SignUpModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.getCardsList()
        }
        else
        {
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            if data.isSuspended == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            }
        }
    }
    
    func didFailDataUpdateWithError3(error: Error)
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
extension PaymentCardsVC : UITableViewDataSource,UITableViewDelegate {
    
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
        
        cell.cardNumberLabel.text = cardNumber
        cell.carHolderNameLabel.text = existingCards[indexPath.row].cardHolderName
        
        if existingCards[indexPath.row].status == "0"{
            cell.primaryLabel.isHidden = true
            cell.primaryLabelHeight.constant = 0
        }
        else{
            cell.primaryLabel.isHidden = false
            cell.primaryLabelHeight.constant = 19
        }
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCard(button:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteCard(button : UIButton)
    {
        dataSource.cardID = existingCards[button.tag].id ?? ""
        if existingCards[button.tag].status == "1"{
            self.view.makeToast("Before deleting please set another card as primary")
        }
        else{
            //existingCards.remove(at: button.tag)
            Connection.svprogressHudShow(view: self)
            dataSource.deleteCard()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC{
            vc.cardID = existingCards[indexPath.row].id ?? ""
            if existingCards[indexPath.row].cardName == "Amex"{
                vc.maxLength = 4
            }
            if existingCards[indexPath.row].status == "1"{
                vc.madePrimary = true
            }
            vc.addNewCardDelegate = self
        }
    }
}
