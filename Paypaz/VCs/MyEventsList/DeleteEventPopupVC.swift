//
//  DeleteEventPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class DeleteEventPopupVC : CustomViewController {

    weak var delegate : PopupDelegate?
    
//    @IBOutlet weak var lbl_Title   : UILabel!
//    @IBOutlet weak var lbl_message : UILabel!
//    
//    var popupData : (title:String, msg:String)?
    
    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    

   // MARK: - --- Action ----
    @IBAction func btn_Yes(_ sender:UIButton) {
        self.dismiss(animated: false) {[weak self] in
            self?.delegate?.isClickedButton()
        }
        
    }
    @IBAction func btn_No(_ sender:UIButton) {
        self.dismiss(animated: false) {//[weak self] in
          
        }
        
    }
   
    
}
