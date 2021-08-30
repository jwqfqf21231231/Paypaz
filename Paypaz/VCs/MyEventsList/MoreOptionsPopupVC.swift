//
//  MoreOptionsPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 12/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

protocol MoreOptionsDelegate : class {
    func hasSelectedOption(type:OptionType,eventID:String)
}

enum OptionType {
    case edit
    case delete
}
class MoreOptionsPopupVC : CustomViewController {
    weak var delegate : MoreOptionsDelegate?
    var eventID = ""
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    // MARK: - ---- Action ----
    @IBAction func btn_Cancel(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Edit(_ sender:UIButton) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.hasSelectedOption(type: .edit,eventID: self?.eventID ?? "")
        }
    }
    @IBAction func btn_Delete(_ sender:UIButton) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.hasSelectedOption(type: .delete,eventID: self?.eventID ?? "")
        }
    }
    
}

