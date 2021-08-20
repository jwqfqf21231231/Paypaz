//
//  InviteMembersVC.swift
//  Paypaz
//
//  Created by MAC on 18/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Contacts
import libPhoneNumber_iOS
class InviteMembersVC: CustomViewController {
    
    var img = UIImage()
    var contactDetails = [ContactInfo]()
    var isPublicStatus = "0"
    var isInviteMemberStatus = "0"
    var eventID = ""
    weak var delegate : PopupDelegate?
    
    @IBOutlet weak var isPublic : UISwitch!
    @IBOutlet weak var isInviteMember : UISwitch!
    @IBOutlet weak var tableView_Members        : UITableView!{
        didSet{
            tableView_Members.dataSource = self
            tableView_Members.delegate   = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPublic.addTarget(self, action: #selector(onSwitchValueChange(swtch:)), for: .valueChanged)
        self.isInviteMember.addTarget(self, action: #selector(onSwitchValueChange(swtch:)), for: .valueChanged)
        tableView_Members.separatorStyle = .none
        // Do any additional setup after loading the view.
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
    func fetchContacts()
    {
        fetchContacts(completion: {contacts in
            contacts.forEach({print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil"), CountryCode: \($0.postalAddresses.first?.value.isoCountryCode ?? "nil")")
                               
                if $0.thumbnailImageData != nil
                {
                    self.img = UIImage.init(data: $0.thumbnailImageData!)!
                   
                }
                if ((($0.phoneNumbers.first?.value.stringValue ?? "nil")?.contains("+")) == true){
                    let phoneNumber = "\($0.phoneNumbers.first?.value.stringValue ?? "nil")"
                    let contactDetail = ContactInfo(firstName: $0.givenName, lastName: $0.familyName, phoneNumber:phoneNumber, profilePic:self.img)
                    self.contactDetails.append(contactDetail)
                }
            })
            

        })
        
       
       
    }
    @objc func onSwitchValueChange(swtch:UISwitch)
    {
        switch swtch.tag{
        case 0:
            if(swtch.isOn)
            {
                self.isPublicStatus = "1"
            }
            else
            {
                self.isPublicStatus = "0"
            }
        default:
            if(swtch.isOn)
            {
                self.isInviteMemberStatus = "1"
            }
            else
            {
                self.isInviteMemberStatus = "0"
            }
            if isInviteMemberStatus == "1"
            {
                fetchContacts()
                DispatchQueue.main.async {
                    self.tableView_Members.reloadData()
                }
            }
            else{
                
            }
        }
    }
    @IBAction func btn_Done(_ sender:UIButton)
    {
        if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
            popup.selectedPopupType = .eventCreatedSuccess
            popup.delegate = self
        }
    }
    
}
extension InviteMembersVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as? MemberCell else { return MemberCell() }
        cell.contactName_lbl.text = contactDetails[
            indexPath.row].firstName
        cell.contactNo_lbl.text = contactDetails[indexPath.row].phoneNumber
        cell.btn_tick.tag = indexPath.row
        return cell
    }
    
}
extension InviteMembersVC : PopupDelegate {
    
    func isClickedButton() {
      self.navigationController?.popViewController(animated: false)
        self.delegate?.passEventID?(eventID: self.eventID)
        
        
    }
}
