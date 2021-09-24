//
//  EventDetailVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class EventDetailVC : CustomViewController {
    
    var eventID = ""
    var isFavourite : String?
    var eventDetails : MyEvent?
    var products = [MyProducts]()
    var contacts = [InvitedContacts]()
    private let dataSource = MyPostedEventDataModel()
    
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var lbl_EventName : UILabel!
    @IBOutlet weak var lbl_Price : UILabel!
    @IBOutlet weak var lbl_Description : UILabel!
    @IBOutlet weak var lbl_EventDateTime : UILabel!
    @IBOutlet weak var lbl_EventLocation : UILabel!
    @IBOutlet weak var lbl_HostName : UILabel!
    @IBOutlet weak var img_HostPic : UIImageView!
    @IBOutlet weak var btn_Category : UIButton!
    @IBOutlet weak var view_Invitee : UIView!
    @IBOutlet weak var view_Product : UIView!
    @IBOutlet weak var view_ProductHeight : NSLayoutConstraint!
    @IBOutlet weak var view_InviteeHeight : NSLayoutConstraint!
    @IBOutlet weak var btn_isFavourited : UIButton!
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
    weak var delegate : PopupDelegate?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource.delegate2 = self
        dataSource.delegate3 = self
        if isFavourite == "0"
        {
            btn_isFavourited.isHidden = true
        }
        self.getEventInfo()
        self.getProducts()
        self.getInvitees()
    }
    private func getEventInfo()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.getEvent()
    }
    func getProducts()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getProducts()
        
    }
    func getInvitees()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.getContacts()
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_addToCart(_ sender:RoundButton) {
        if let vc = self.pushVC("AddToCartVC") as? AddToCartVC{
            vc.eventID = self.eventID
            vc.addToCart = true
            vc.successDelegate = self
        }
    }
    @IBAction func btn_ViewMoreProduct(_ sender:RoundButton) {
        if let vc = self.pushVC("ViewAllProductsVC") as? ViewAllProductsVC
        {
            vc.eventName = self.lbl_EventName.text ?? ""
            vc.eventID = self.eventID
        }
    }
    @IBAction func btn_CreatedByUser(_ sender:UIButton) {
        if let vc = self.pushVC("OtherUserProfileVC") as? OtherUserProfileVC{
            vc.userID = eventDetails?.userID ?? ""
        }
    }
    @IBAction func btn_Share(_ sender:UIButton){
        postshareLink(profile_URL: "The text that i want to share")
    }
}
extension EventDetailVC : AddedSuccessfullyPopUp{
    func addedToCart() {
        self.view.makeToast("Event Added To Cart", duration: 1, position: .bottom)
    }
}
