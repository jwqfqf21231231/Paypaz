//
//  MyPostedEventDetailsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class MyPostedEventDetailsVC : CustomViewController {
    
    var eventID = ""
    var eventDetails : MyEvent?
    var products = [MyProducts]()
    private let dataSource = MyPostedEventDataModel()
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var lbl_EventName : UILabel!
    @IBOutlet weak var lbl_Price : UILabel!
    @IBOutlet weak var lbl_Description : UILabel!
    @IBOutlet weak var lbl_EventDateTime : UILabel!
    @IBOutlet weak var lbl_EventLocation : UILabel!
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
    @IBOutlet weak var btn_edit              : RoundButton!
    
    var isEditHidden : Bool?
    
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_edit.alpha = 0.0
        dataSource.delegate = self
        dataSource.delegate2 = self
        self.getEvent()
        self.getProducts()
    }
    private func getEvent()
    {
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.eventID = self.eventID
        dataSource.getEvent()
    }
    private func getProducts()
    {
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.getProducts()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getProducts()
        if self.isEditHidden ?? false {
            self.btn_edit.alpha = 0.0
        } else {
            self.btn_edit.alpha = 1.0
        }
    }
     // MARK: - --- Action ----
       @IBAction func btn_back(_ sender:UIButton) {
          self.navigationController?.popViewController(animated: true)
       }
    @IBAction func btn_Ok(_ sender:UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ViewMoreProduct(_ sender:RoundButton) {
        if let vc = self.pushToVC("ViewAllProductsVC") as? ViewAllProductsVC
        {
            vc.eventID = self.eventID
        }
    }

}
