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
            DispatchQueue.main.async {
                self.tableViewHeight.constant =  self.tableView_AddCards.contentSize.height
            }
            tableView_AddCards.reloadData()
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
extension PaymentCardsVC : AddNewCardDelegate{
    func addNewCard() {
        Connection.svprogressHudShow(view: self)
        dataSource.getCardsList()
    }
}
extension PaymentCardsVC : DeleteCardDataModelDelegate
{
    func didRecieveDataUpdate(data: SignUpModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
        cell.cardNumberLabel.text = existingCards[indexPath.row].cardNumber
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
        existingCards.remove(at: button.tag)
        tableView_AddCards.reloadData()
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView_AddCards.contentSize.height
        }
        Connection.svprogressHudShow(view: self)
        dataSource.deleteCard()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let vc = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC{
            vc.cardID = existingCards[indexPath.row].id ?? ""
        }
    }
}
