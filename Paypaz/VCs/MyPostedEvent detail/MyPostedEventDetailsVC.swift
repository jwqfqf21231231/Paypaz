//
//  MyPostedEventDetailsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol UpdateEventDelegate : class{
    func updateEventData(data : MyEvent?,eventID : String,deleted : Bool?)
}

class MyPostedEventDetailsVC : CustomViewController {
    
    var eventID = ""
    var isPublicStatus = ""
    var isInviteMemberStatus = ""
    var eventDetails : MyEvent?
    var products = [MyProducts]()
    var contacts = [InvitedContacts]()
    weak var updateEventDelegate : UpdateEventDelegate?
    private let dataSource = MyPostedEventDataModel()
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var lbl_EventName : UILabel!
    @IBOutlet weak var lbl_Price : UILabel!
    @IBOutlet weak var lbl_Description : UILabel!
    @IBOutlet weak var lbl_EventDateTime : UILabel!
    @IBOutlet weak var lbl_EventLocation : UILabel!
    @IBOutlet weak var btn_edit : RoundButton!
    @IBOutlet weak var btn_Category : UIButton!
    @IBOutlet weak var view_Product : UIView!
    @IBOutlet weak var view_ProductHeight : NSLayoutConstraint!
    @IBOutlet weak var view_Invitee : UIView!
    @IBOutlet weak var view_InviteeHeight : NSLayoutConstraint!
    @IBOutlet weak var img_UserPic : UIImageView!
    @IBOutlet weak var lbl_UserName : UILabel!
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
        dataSource.delegate = self
        dataSource.delegate2 = self
        dataSource.delegate3 = self
        self.getEvent()
        self.getProducts()
        self.getInvitees()
    }
    func getEvent()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.getEvent()
    }
    func getProducts()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.getProducts()
        
    }
    func getInvitees()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.getContacts()
    }
    // MARK: ---- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
        updateEventDelegate?.updateEventData(data: eventDetails, eventID: eventID, deleted: false)
    }
    @IBAction func btn_Ok(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ViewMoreProduct(_ sender:RoundButton) {
        if let vc = self.pushToVC("ViewAllProductsVC") as? ViewAllProductsVC
        {
            vc.updateProductsListDelegate = self
            vc.eventName = self.lbl_EventName.text ?? ""
            vc.eventID = self.eventID
        }
    }
    @IBAction func btn_Edit(_ sender:UIButton){
        if let popup = self.presentPopUpVC("MoreOptionsPopupVC", animated: true) as? MoreOptionsPopupVC {
            popup.eventID = eventID
            popup.isPublic = isPublicStatus
            popup.isInvitedMember = isInviteMemberStatus
            popup.delegate = self
        }
    }
    
}
