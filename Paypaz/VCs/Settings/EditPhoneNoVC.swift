//
//  EditPhoneNoVC.swift
//  Paypaz
//
//  Created by mac on 10/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

class EditPhoneNoVC: UIViewController {
    @IBOutlet weak var txt_PhoneNo : RoundTextField!

    @IBOutlet weak var code_btn : UIButton!
    //Country Code and Phone Code
    var country_code = "IN"
    var phone_code = "+91"
    var textStr = ""
    var phoneNo = ""
    private var nbPhoneNumber: NBPhoneNumber?
    private var formatter: NBAsYouTypeFormatter?
    private lazy var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.txt_PhoneNo.delegate = self

        hideKeyboardWhenTappedArround()
        updatePlaceholder(country_code)

     
    }
    
}
