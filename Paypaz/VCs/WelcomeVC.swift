//
//  WelcomeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Contacts
import libPhoneNumber_iOS
class WelcomeVC : CustomViewController {
    
    var img = UIImage()
    var contactDetails = [ContactInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
            })
            
        }
    }
    // MARK:- Getting all contacts
    func fetchContacts()
    {
        fetchContacts(completion: {contacts in
            contacts.forEach({print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil"), CountryCode: \($0.postalAddresses.first?.value.isoCountryCode ?? "nil")")
                
                if $0.thumbnailImageData != nil
                {
                    self.img = UIImage.init(data: $0.thumbnailImageData!)!
                    
                }
                
                let CountryCode = "\($0.postalAddresses.first?.value.isoCountryCode ?? "nil")"
                let phoneNumber = "\($0.phoneNumbers.first?.value.stringValue ?? "nil")"
                let contactDetail = ContactInfo(firstName: $0.givenName, lastName: $0.familyName, coutryCode:CountryCode, phoneNumber:phoneNumber, profilePic:self.img)
                self.contactDetails.append(contactDetail)
                
            })
            
        })
        
        
        
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_getStarted(_ sender:UIButton) {
        
        fetchContacts()
        _ = self.pushToVC("LoginVC")
    }
    
}


