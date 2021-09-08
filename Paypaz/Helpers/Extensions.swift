//
//  Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Network

class CustomViewController : UIViewController {
    
    var didChangeNetworkConnection : ((Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.addNetworkCheckHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    func addNetworkCheckHandler() {
//        if #available(iOS 12.0, *) {
//            let appDel = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
//            appDel.monitor.start(queue: .global())
//            appDel.monitor.pathUpdateHandler = { [weak self] path in
//                
//                //  DispatchQueue.main.async {
//                if path.status == .satisfied {
//                    appDel.isNetworkConnected = true
//                    self?.didChangeNetworkConnection?(true)
//                } else {
//                    appDel.isNetworkConnected = false
//                    self?.didChangeNetworkConnection?(false)
//                }
//                // }
//            }
//        }
    }
    
}

//MARK:- ---- Text Field Delegate ---
extension CustomViewController : UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            field.border_Color = UIColor(named: "SkyblueColor")
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? RoundTextField {
            if(field.tag == 101)
            {
                field.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            }
            else
            {
                field.border_Color = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
            }
        }
    }
}
//MARK:- ---- Text View Delegate ---
extension CustomViewController : UITextViewDelegate{
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if let view = textView as? RoundTextView{
            view.border_Color = UIColor(named: "SkyblueColor")
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if let view = textView as? RoundTextView{
            if(view.tag == 101)
            {
                view.border_Color = UIColor(red: 238/255, green: 243/255, blue: 255/255, alpha: 1)
            }
            else
            {
                view.border_Color = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
            }
        }
    }
}

