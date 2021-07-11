//
//  MyTicketDetailVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 20/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyTicketDetailVC : CustomViewController {

    @IBOutlet weak var collectionViewProducts : UICollectionView!{
        didSet {
            collectionViewProducts.dataSource = self
            collectionViewProducts.delegate   = self
        }
    }
    
   //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

     // MARK: - --- Action ----
       @IBAction func btn_back(_ sender:UIButton) {
          self.navigationController?.popViewController(animated: true)
       }

}
