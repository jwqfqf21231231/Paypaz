//
//  PaymentCardsVC.swift
//  Paypaz
//
//  Created by MAC on 28/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class PaymentCardsVC: UIViewController {
    var existingCards = [CardsList](){
        didSet{
            tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
            tableView_AddCards.reloadData()
            tableView_AddCards.layoutIfNeeded()
            self.tableViewHeight.constant = self.tableView_AddCards.contentSize.height
        }
    }
    @IBOutlet weak var tableView_AddCards       : UITableView!{
        didSet{
            tableView_AddCards.dataSource = self
            tableView_AddCards.delegate   = self
        }
    }
    @IBOutlet weak var tableViewHeight : NSLayoutConstraint!
    public let dataSource = CreateCardDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.cardListDelegate = self
        dataSource.deleteCardDelegate = self
        getCardsList()
        // Do any additional setup after loading the view.
    }
    func getCardsList(){
        Connection.svprogressHudShow(view: self)
        dataSource.getCardsList()
    }
    @IBAction func btn_addPaymentCards(_ sender:UIButton)
    {
        if let vc = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC
        {
            if self.existingCards.count == 0{
                vc.strictlyPrimary = true
            }
            vc.fromSettings = true
            vc.existingCards = existingCards
            vc.addNewCardDelegate = self
        }
    }
    @IBAction func btn_Back(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
}

