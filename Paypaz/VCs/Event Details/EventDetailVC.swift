//
//  EventDetailVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventDetailVC : CustomViewController {
    
    @IBOutlet weak var collectionView_Products : UICollectionView!{
        didSet {
            collectionView_Products.dataSource = self
            collectionView_Products.delegate   = self
        }
    }
    @IBOutlet weak var collectionView_People : UICollectionView!{
        didSet {
            collectionView_People.dataSource = self
            collectionView_People.delegate   = self
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

    @IBAction func btn_addToCart(_ sender:RoundButton) {
         _ = self.pushToVC("MyCartVC")
    }
    @IBAction func btn_ViewMoreProduct(_ sender:RoundButton) {
         _ = self.pushToVC("ViewAllProductsVC")
    }
    @IBAction func btn_CreatedByUser(_ sender:UIButton) {
         _ = self.pushToVC("OtherUserProfileVC")
    }
}
