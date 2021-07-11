//
//  FilterVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class FilterVC : CustomViewController {
    
    
    //MARK:- --- View Life Cycle ----
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
    // MARK: - --- Action ----
    @IBAction func btn_Cancel(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Apply(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
