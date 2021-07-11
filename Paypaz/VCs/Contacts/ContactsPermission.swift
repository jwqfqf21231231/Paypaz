//
//  ContactsPermission.swift
//  Paypaz
//
//  Created by MACOSX on 07/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Contacts
class ContactsPermission: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK:- Fetch All Contacts of Phone
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
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
    var arrpic = NSMutableArray()
    var arrfname  = [String]()
    var arrlname  = [String]()
    var arrnumber = [String]()
    @IBAction func btn_GivePermission(_ sender:UIButton)
    {


            fetchContacts(completion: {contacts in
                contacts.forEach({print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                    self.arrfname.append("\($0.givenName)")
                    self.arrlname.append("\($0.familyName)")
                    self.arrnumber.append("\($0.phoneNumbers.first?.value.stringValue ?? "nil")")
                    var img = UIImage()
                    if $0.thumbnailImageData != nil
                    {
                        img = UIImage.init(data: $0.thumbnailImageData!)!
                        self.arrpic.add(img)
                    }
                    else
                    {
                        self.arrpic.add("")
                    }
                })
//                if contacts.count > 0
//                {
//                    self.tablev.reloadData()
//                }
            })
        for i in arrfname
        {
            print(i)
        }
        
       /* var contacts: [CNContact] = {
                let contactStore = CNContactStore()
                let keysToFetch: [CNKeyDescriptor] = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPostalAddressesKey as CNKeyDescriptor,
                    CNContactEmailAddressesKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                    CNContactImageDataAvailableKey as CNKeyDescriptor,
                    CNContactThumbnailImageDataKey as CNKeyDescriptor]

                // Get all the containers
                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch {
                    print("Error fetching containers")
                }

                var results: [CNContact] = []

                // Iterate all containers and append their contacts to our results array
                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                        results.append(contentsOf: containerResults)
                    } catch {
                        print("Error fetching results for container")
                    }
                }

                return results
            }()*/
         
         
         //=================================================
         
      //  If you want to get ALL fields of a contact with known identifier:

        //let contact = unifiedContact(withIdentifier: identifier, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
        //This gives you an access to ALL fields, such as adresses, phone numbers, full name, etc.

        //To retrieve fullName then:

       // let fullname = CNContactFormatter.string(from: contact, style: .fullName)
    
    
    }
}
