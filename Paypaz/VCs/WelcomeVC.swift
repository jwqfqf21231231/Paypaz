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
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
                return
            }
        do {
            let numberProto: NBPhoneNumber = try phoneUtil.parse("+1-202-555-0184", defaultRegion: "IN")
            let ex = try phoneUtil.getExampleNumber("IN")
            let countryCode = numberProto.countryCode
            let number = numberProto.clearCountryCodeSource()
                        //Log.d("code", "" + ex)
                let formattedString: String = try phoneUtil.format(numberProto, numberFormat: .E164)

                NSLog("[%@]", formattedString)
            print("Number Prototype:\(numberProto)")
            print("Country Code:\(countryCode)")
            print("Example Number:\(ex)")
            print("Removed Country code :\(number)")
            }
        catch let error as NSError {
                print(error.localizedDescription)
            }
        
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
    
    // MARK:- Getting Current Location
    private func getLocation()
    {
        let instance = LocationManager.shared
        instance.getUserLocation { (lat, long) in
            if lat != nil && long != nil{
                UserDefaults.standard.setLatitude(value: "\(lat ?? 0.0)")
                UserDefaults.standard.setLongitude(value: "\(long ?? 0.0)")
                
            }
            
        }
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_getStarted(_ sender:UIButton) {
        getLocation()
        fetchContacts()
        
        _ = self.pushToVC("LoginVC")
    }

}


