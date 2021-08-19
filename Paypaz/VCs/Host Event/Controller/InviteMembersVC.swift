//
//  InviteMembersVC.swift
//  Paypaz
//
//  Created by MAC on 18/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class InviteMembersVC: UIViewController {
    
    var isPublicStatus = ""
    var isInviteMemberStatus = ""
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
            
        }
    }
    @IBAction func btn_Done(_ sender:UIButton)
    {
        
    }
    
}
extension InviteMembersVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as? MemberCell else { return MemberCell() }
        cell.contactName_lbl.text = "Ajay"
        cell.contactNo_lbl.text = "+91 8309762337"
        
        return cell
    }
    
}
