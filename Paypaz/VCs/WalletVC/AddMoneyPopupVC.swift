//
//  AddMoneyPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol AddMoneyPopupDelegate : class {
    func isSelectedType(bank:Bool,amount:String)
}

class AddMoneyPopupVC  : CustomViewController {
    
    weak var delegate : AddMoneyPopupDelegate?
    var selectedType  : AddMoneyType?
    
    @IBOutlet weak var txt_AmountToAdd : UITextField!
    @IBOutlet weak var btn_BankAcc     : RoundButton!
    @IBOutlet weak var btn_DebitCredit : RoundButton!
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.selectedType = .BankAccount
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
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_AddMoney(_ sender:UIButton) {
        let amount = (txt_AmountToAdd.text! as NSString).integerValue
        if amount > 0{
            let selected = self.selectedType ?? AddMoneyType.BankAccount
            self.dismiss(animated: false) { [weak self] in
                self?.delegate?.isSelectedType(bank: selected == .BankAccount,amount: self?.txt_AmountToAdd.text ?? "")
            }
        }
        else{
            self.view.makeToast("The amount must be greater than 0")
        }
    }
    @IBAction func btn_BankAccount(_ sender:UIButton) {
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
    }
}
