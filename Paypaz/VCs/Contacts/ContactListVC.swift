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
enum PaymentOption
{
    case Request
    case Pay
}
class ContactListVC : CustomViewController {
    
    @IBOutlet weak var tableView_Contacts : UITableView! {
        didSet {
            tableView_Contacts.dataSource = self
            tableView_Contacts.delegate   = self
        }
    }
    @IBOutlet weak var txt_Search : UITextField!
    @IBOutlet weak var view_ContactsList : UIView!
    var permissionGranted : Bool?
    var contactName : String?
    var phoneNumber : NSNumber?
    var phoneCode : NSNumber?
    var paymentOption : PaymentOption?
    var img = UIImage()
    var isLocalContactSelected : Bool?
    var isRequestingMoney      : Bool?
    var contactDetails = [ContactInfo]()
    var filteredContactDetails = [ContactInfo]()
    weak var delegate : ContactSelectedDelegate?
    let dataSource = VerifyContactDataModel()
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        fetchContacts()
        
        self.txt_Search.addTarget(self, action: #selector(searchEventAsPerText(_:)), for: .editingChanged)
        
        //  self.selectLocalPayment()
    }
    @objc func searchEventAsPerText(_ textField:UITextField)
    {
        self.filteredContactDetails.removeAll()
        if textField.text?.count != 0 {
            for contactData in self.contactDetails {
                let isMatchingEventName : NSString = ((contactData.firstName ?? "") + " " + (contactData.lastName ?? "")) as NSString
                let range = isMatchingEventName.lowercased.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filteredContactDetails.append(contactData)
                }
            }
        } else {
            self.filteredContactDetails = self.contactDetails
        }
        self.tableView_Contacts.reloadData()
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
                    self.permissionGranted = true
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
                    self.permissionGranted = false
                    print("Error \(error?.localizedDescription ?? "")")
                }
                if self.permissionGranted ?? false{
                    self.tableView_Contacts.reloadData()
                    self.view_ContactsList.alpha = 1
                }
                else{
                    self.view_ContactsList.alpha = 0
                }
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
                    self.filteredContactDetails.append(contactDetail)
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
        if permissionGranted ?? false{
            self.view_ContactsList.alpha = 1
        }
        else{
            let permissionAlert = UIAlertController(title: "Contacts Access", message: "Requires contacts access to take advantage of this feature. Please provide contacts access from settings", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let settingAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                guard let appSettingURl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(appSettingURl) {
                    UIApplication.shared.open(appSettingURl, options: [:], completionHandler: nil)
                }
            }
            permissionAlert.addAction(cancelAction)
            permissionAlert.addAction(settingAction)
            present(permissionAlert, animated: true, completion: nil)
        }
    }
    
}
