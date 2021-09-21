//
//  ContactListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Contacts
import libPhoneNumber_iOS
protocol ContactSelectedDelegate : class {
    func isSelectedContact(for request:Bool)
}
class ContactListVC : CustomViewController {
    
    @IBOutlet weak var tableView_Contacts : UITableView! {
        didSet {
            tableView_Contacts.dataSource = self
            tableView_Contacts.delegate   = self
        }
    }
//    @IBOutlet weak var btn_Local   : UIButton!
//    @IBOutlet weak var btn_Global  : UIButton!
//    @IBOutlet weak var view_Local  : UIView!
//    @IBOutlet weak var view_Global : UIView!
    @IBOutlet weak var view_ContactsList : UIView!
    
    var img = UIImage()
    var isLocalContactSelected : Bool?
    var isRequestingMoney      : Bool?
    var contactDetails = [ContactInfo]()
    weak var delegate : ContactSelectedDelegate?
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        self.view_ContactsList.alpha = 0.0
      //  self.selectLocalPayment()
    }
    
 /*   private func selectLocalPayment() {
        self.isLocalContactSelected = true
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Local.backgroundColor  = lightBlue
        self.view_Global.backgroundColor = .clear
        self.btn_Local.setTitleColor(.white, for: .normal)
        self.btn_Global.setTitleColor(lightBlue, for: .normal)
    }
    private func selectGlobalPayment() {
        self.isLocalContactSelected = false
        let lightBlue = UIColor(red: 0.44, green: 0.60, blue: 1.00, alpha: 1.00)
        self.view_Global.backgroundColor = lightBlue
        self.view_Local.backgroundColor  = .clear
        self.btn_Global.setTitleColor(.white, for: .normal)
        self.btn_Local.setTitleColor(lightBlue, for: .normal)
    }*/
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey,CNContactUrlAddressesKey,CNContactPostalAddressesKey] as [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = .userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results)
                    
                }else{
                    print("Error \(error?.localizedDescription ?? "")")
                }
                self.tableView_Contacts.reloadData()
            })
        }
        
    }
    func fetchContacts()
    {
        fetchContacts(completion: {contacts in
            contacts.forEach({print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil"), CountryCode: \($0.postalAddresses.first?.value.isoCountryCode ?? "nil")")
                
                if $0.thumbnailImageData != nil
                {
                    self.img = UIImage.init(data: $0.thumbnailImageData!)!
                }
                else{
                    self.img = UIImage(named: "place_holder")!
                }
                
                if ((($0.phoneNumbers.first?.value.stringValue ?? "nil")?.contains("+")) == true){
                    
                    let phoneNumber = "\($0.phoneNumbers.first?.value.stringValue ?? "nil")"
                    let contactDetail = ContactInfo(firstName: $0.givenName, lastName: $0.familyName, phoneNumber:phoneNumber, profilePic:self.img, isInvited: false)
                    self.contactDetails.append(contactDetail)
                }
            })
        })
    }
    // MARK: - --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   /* @IBAction func btn_LocalPayment(_ sender:UIButton) {
        self.selectLocalPayment()
    }
    @IBAction func btn_GlobalPayment(_ sender:UIButton) {
        self.selectGlobalPayment()
    }*/
    @IBAction func btn_Scanner(_ sender:UIButton) {
        _ = self.pushVC("QRCodeScannerVC")
    }
    @IBAction func btn_GivePermission(_ sender:UIButton) {
        self.view_ContactsList.alpha = 1.0
    }
}
