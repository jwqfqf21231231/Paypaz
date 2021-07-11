//
//  MoneyAddedSuccessPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

enum AddMoneyType {
    case BankAccount
    case DebitCreditCard
    case MoneySentSuccess
}
class MoneyAddedSuccessPopupVC  : CustomViewController {
    
    weak var delegate     : PopupDelegate?
    var selectedMoneyType : AddMoneyType?
    
    @IBOutlet weak var img_icon  : UIImageView!
    @IBOutlet weak var lbl_title : UILabel!
    @IBOutlet weak var bg_View   : RoundView!
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bg_View.alpha        = 0.0
        self.view.backgroundColor = UIColor.clear
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if self.selectedMoneyType == AddMoneyType.BankAccount {
            self.img_icon.image = UIImage(named: "bank_tick")
            
        } else if self.selectedMoneyType == AddMoneyType.MoneySentSuccess {
            self.img_icon.image = UIImage(named: "bank_tick")
            self.lbl_title.text = "Money Sent Successfully"
        }
        self.bg_View.alpha      = 1.0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    // MARK: - --- Action ----
  
    @IBAction func btn_Continue(_ sender:UIButton) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.isClickedButton()
        }
    }
}
