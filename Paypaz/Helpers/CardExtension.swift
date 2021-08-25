//
//  CardExtension.swift
//  Paypaz
//
//  Created by mac on 23/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Network
import DropDown

class CardViewController : UIViewController {
    
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
//            if #available(iOS 12.0, *) {
//                let appDel = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
//                appDel.monitor.start(queue: .global())
//                appDel.monitor.pathUpdateHandler = { [weak self] path in
//
//                  //  DispatchQueue.main.async {
//                        if path.status == .satisfied {
//                            appDel.isNetworkConnected = true
//                            self?.didChangeNetworkConnection?(true)
//                        } else {
//                            appDel.isNetworkConnected = false
//                            self?.didChangeNetworkConnection?(false)
//                        }
//                   // }
//                }
//            }
        }
    
    func pushToVC (_ identifier : String, animated:Bool = false) -> UIViewController{
 
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return UIViewController() }
        self.navigationController?.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    func presentPopUpVC(_ identifier : String, animated:Bool) -> UIViewController{
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier)
            else { return UIViewController() }
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: animated, completion: nil)
        return viewController
        
    }
    func presentVC(_ identifier : String) -> UIViewController {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier)
            else { return UIViewController() }
        
        viewController.modalPresentationStyle = .fullScreen
        
            self.present(viewController, animated: true, completion: nil)
        return viewController
        
    }
    
    func showAlertPopup(withMsg message:String, withOKbtn okbutton:Bool){
        //NOTE:- Indicator is also an alert, so when indicator will hide, then show this alert
        // to avoid 'already presenting view controller' warning
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let attrString = NSAttributedString(string: Constants.appName, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "BlueColor") ?? UIColor.blue])
            let alertCon = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertCon.setValue(attrString, forKey: "attributedTitle")
            
            alertCon.view.tintColor = UIColor.darkGray
            self.present(alertCon, animated: true, completion: nil)
            
            if okbutton {
                //Show ok button
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertCon.addAction(OKAction)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    //MARK:-
    //Hide keyboard on tap outside
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
   
}
//MARK:- ----------------------------
//MARK:- ---- Text field delegate ---

