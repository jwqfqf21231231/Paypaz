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
    @IBOutlet weak var eventImage               : UIImageView!
    @IBOutlet weak var eventNameLabel           : UILabel!
    @IBOutlet weak var eventDescriptionLabel    : UILabel!
    @IBOutlet weak var ticketPriceLabel         : UILabel!
    @IBOutlet weak var endDateLabel             : UILabel!
    @IBOutlet weak var categoryButton           : UIButton!
    @IBOutlet weak var orderNumberLabel         : UILabel!
    @IBOutlet weak var hostImage : UIImageView!
    @IBOutlet weak var hostName : UILabel!
    @IBOutlet weak var paymentMethodImage : UIImageView!
    @IBOutlet weak var paymentMethodName : UILabel!
    @IBOutlet weak var hideProductsView : UIView!
    @IBOutlet weak var productsViewHight : NSLayoutConstraint!
    
    private let userTicketsDataSource = UserTicketsDataModel()
    
    var orderID = ""
    var ticketProducts:[TicketProducts]?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        userTicketsDataSource.ticketDetailsDelegate = self
        userTicketsDataSource.orderID = self.orderID
        Connection.svprogressHudShow(view: self)
        userTicketsDataSource.getTicketDetails()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Share(_ sender:UIButton){
        postshareLink(profile_URL: "The text that i want to share")
    }
    
}
