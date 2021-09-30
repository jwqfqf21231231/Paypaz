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
            tableView_AddCards.reloadData()
            DispatchQueue.main.async {
                if self.existingCards.count == 1{
                        self.tableViewHeight.constant = 90.33
                    self.view.layoutIfNeeded()
                }
                else{
                    self.tableViewHeight.constant = self.tableView_AddCards.contentSize.height
                    self.view.layoutIfNeeded()
                }
            }
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
            vc.addNewCardDelegate = self
        }
    }
    @IBAction func btn_Back(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
}

