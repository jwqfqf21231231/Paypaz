//
//  TermsPoliciesVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import WebKit

class TermsPoliciesVC  : CustomViewController {
    
    private let dataSource = Terms_PoliciesDataModel()

    @IBOutlet weak var webView : WKWebView!
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        Connection.svprogressHudShow(view: self)
        dataSource.getContent()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- ---- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension TermsPoliciesVC : Terms_PoliciesDelegate
{
    
    func didRecieveDataUpdate(data:TermsPoliciesModel )
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            webView.loadHTMLString(data.data?.content ?? "", baseURL: nil)
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            }
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
