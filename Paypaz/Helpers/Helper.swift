//
//  Helper.swift
//  Paypaz
//
//  Created by mac on 03/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit
import DropDown


class Helper : NSObject
{
    class func isEmailValid(email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    class func validatePassword(passwordString : String) -> Bool
    {
       let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[0-9])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{8,16}$")
        
        return password.evaluate(with: passwordString)
    }
    class func clearUserDataAndSignOut()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "registerToken")
        userDefaults.removeObject(forKey: "latitude")
        userDefaults.removeObject(forKey: "longitude")
        userDefaults.removeObject(forKey: "email")
        userDefaults.removeObject(forKey: "phoneCode")
        userDefaults.removeObject(forKey: "countryCode")
        userDefaults.removeObject(forKey: "isLoggedIn")
        userDefaults.removeObject(forKey: "notificationStatus")
    }
    
}


extension UIViewController
{
    func showAlert(withMsg message:String, withOKbtn okbutton:Bool){
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
    func hideKeyboardWhenTappedArround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideSystemKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideSystemKeyboard() {
        view.endEditing(true)
    }
    
    
    func getDataFormFile() -> ([CountiesWithPhoneModel],String)
    {
        var country_code = [CountiesWithPhoneModel]()
        if let jsonFile = Bundle.main.path(forResource: "CountryCodes", ofType: "json")  {
            let url = URL.init(fileURLWithPath: jsonFile)
            do{
                let data  = try Data.init(contentsOf: url)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let json = jsonData as? [[String:String]]
                {
                    for list in json{
                        let data = CountiesWithPhoneModel.init(dial_code: (list["dial_code"] as? String ?? ""), countryName: (list["name"] as? String ?? ""), code: (list["code"] as? String ?? ""))
                        country_code.append(data)
                    }
                    return (country_code,"")
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return ([],"error")
    }
    struct CountiesWithPhoneModel {
        var dial_code :String?
        var countryName : String?
        var code :String?
    }
}
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
        let attrs = [NSAttributedString.Key.font : UIFont(name: "Segoe UI", size: 16.0) ?? UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : color]
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
      //  self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttributes(attrs, range: range)
    }

}
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func stringByRemovingAll(characters: [Character]) -> String {
           return String(self.filter({ !characters.contains($0) }))
       }
   
}
extension UIButton{
    func addDropDown(forDataSource data:[String], completion: @escaping(String)->Void) {
        resignFirstResponder()
        let selectTypeDropDown = DropDown()
       // selectTypeDropDown.textFont = UIFont.init(name: "sf_pro_text_regular", size: 10)
        selectTypeDropDown.textColor = UIColor.black
        selectTypeDropDown.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        selectTypeDropDown.width = self.frame.width
        selectTypeDropDown.cellHeight = 38
        selectTypeDropDown.direction = .bottom
        selectTypeDropDown.cornerRadius = 5
        selectTypeDropDown.anchorView = self
        selectTypeDropDown.bottomOffset = CGPoint(x: 0, y:(selectTypeDropDown.anchorView?.plainView.bounds.height)!)
        selectTypeDropDown.topOffset = CGPoint(x: 0, y:-(selectTypeDropDown.anchorView?.plainView.bounds.height)!)
        selectTypeDropDown.dataSource = data
        selectTypeDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            self.setTitle(item, for: .normal)// = item
            self.resignFirstResponder()
            print("Selected item: \(item) at index: \(index)")
            completion(item)
        }
        selectTypeDropDown.show()
    }
}
