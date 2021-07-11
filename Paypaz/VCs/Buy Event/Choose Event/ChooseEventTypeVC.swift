//
//  ChooseEventVC.swift
//  Paypaz
//
//  Created by MACOSX on 05/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class ChooseEventTypeVC: CustomViewController {
    
    var doBuyEvent : Bool?
    var selectedEventData : ((_ eventName:String,_ selectedID:String) -> Void)?
    private let dataSource = ChooseEventDataModel()
    var eventData = [Events]()
    var filteredEventData = [Events]()
    @IBOutlet weak var txt_Search : UITextField!
    @IBOutlet weak var collectionView_Events:UICollectionView!{
        didSet{
            collectionView_Events.delegate = self
            collectionView_Events.dataSource = self
        }
    }
    @objc func searchEventAsPerText(_ textField:UITextField)
    {
        self.filteredEventData.removeAll()
        if textField.text?.count != 0 {
            for eventData in self.eventData {
                let isMatchingEventName : NSString = eventData.name! as NSString
                let range = isMatchingEventName.lowercased.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filteredEventData.append(eventData)
                }
            }
        } else {
            self.filteredEventData = self.eventData
        }
        self.collectionView_Events.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_Search.addTarget(self, action: #selector(searchEventAsPerText(_:)), for: .editingChanged)
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.delegate = self
        dataSource.getEventTypes()
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
