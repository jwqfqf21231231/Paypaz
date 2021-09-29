//
//  PaymentCardsVC.swift
//  Paypaz
//
//  Created by MAC on 28/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class PaymentCardsVC: UIViewController {
    var existingCards = [CardsList]()
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
        Connection.svprogressHudShow(view: self)
        dataSource.getCardsList()
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_addPaymentCards(_ sender:UIButton)
    {
        if let vc = self.pushVC("CreditDebitCardVC") as? CreditDebitCardVC
        {
            vc.fromSettings = true
            vc.addNewCardDelegate = self
        }
    }
    @IBAction func btn_Back(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
}

