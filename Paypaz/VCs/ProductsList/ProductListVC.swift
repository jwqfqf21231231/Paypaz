//
//  ProductListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ProductListVC : CustomViewController {
    
    weak var delegate : PopupDelegate?
    
    @IBOutlet weak var tableView_Products : UITableView! {
        didSet {
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    @IBOutlet weak var tableView_height : NSLayoutConstraint!
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
     let screenSize = UIScreen.main.bounds.size.height * 0.65
     let tblHeight  = self.tableView_Products.contentSize.height
     if tblHeight > screenSize {
         self.tableView_height.constant = screenSize
     } else {
         self.tableView_height.constant = self.tableView_Products.contentSize.height
     }
        
    }
    // MARK: - --- Action ----
    @IBAction func btn_Cancel(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Done(_ sender:UIButton) {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.isClickedButton()
        }
    }
}
