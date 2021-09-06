//
//  FilterVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol FilterData:class {
    func filterData(distance:String,date:String)
}
class FilterVC : CustomViewController {
    
    @IBOutlet weak var distance:UISlider!
    @IBOutlet weak var txt_Date : UITextField!
    @IBOutlet weak var txt_Time : UITextField!
    weak var delegate : FilterData?
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
        delegate?.filterData(distance: "5", date: "4")
    }
}
