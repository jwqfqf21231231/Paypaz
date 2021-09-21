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
    class func clearUserDataAndSignOut()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userID")
        userDefaults.removeObject(forKey: "registerToken")
        userDefaults.removeObject(forKey: "email")
        userDefaults.removeObject(forKey: "phoneNo")
        userDefaults.removeObject(forKey: "phoneCode")
        userDefaults.removeObject(forKey: "countryCode")
        userDefaults.removeObject(forKey: "isLoggedIn")
        userDefaults.removeObject(forKey: "isNotification")
        userDefaults.removeObject(forKey: "isPasscode")
        userDefaults.removeObject(forKey: "isPin")
        userDefaults.removeObject(forKey: "isProfile")
        userDefaults.removeObject(forKey: "isVerify")
        userDefaults.removeObject(forKey: "isVerifyCard")
        userDefaults.removeObject(forKey: "passcode")
        userDefaults.removeObject(forKey: "notificationStatus")
    }
    
}

extension UIViewController
{
    func postshareLink(profile_URL:String){
        let objectsToShare = [profile_URL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success{
                print("Successfully Send link")
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat
        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()
        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
    
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
    
    func pushVC (_ identifier : String, animated:Bool = true) -> UIViewController
    {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return UIViewController() }
        self.navigationController?.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    func presentPopUpVC(_ identifier : String, animated:Bool) -> UIViewController
    {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        else { return UIViewController() }
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: animated, completion: nil)
        return viewController
    }
    
    func presentVC(_ identifier : String) -> UIViewController
    {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        else { return UIViewController() }
        
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        return viewController
    }
    
    //Hide keyboard on tap outside
    func hideKeyboardWhenTappedArround()
    {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideSystemKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideSystemKeyboard()
    {
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
                        let data = CountiesWithPhoneModel.init(dial_code: (list["dial_code"] ?? ""), countryName: (list["name"] ?? ""), code: (list["code"] ?? ""))
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

extension NSMutableAttributedString
{
    func setColor(color: UIColor, forText stringValue: String) {
        let attrs = [NSAttributedString.Key.font : UIFont(name: "Segoe UI", size: 16.0) ?? UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : color]
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        //  self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttributes(attrs, range: range)
    }
}

extension UITextField
{
    func isEmptyOrWhitespace() -> Bool {
        if(self.text!.isEmpty) {
            return true
        }
        return (self.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
    }
    func isEmailValid() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text!)
    }
    func validatePassword() -> Bool
    {
        let password = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[0-9])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{8,16}$")
        
        return password.evaluate(with: self.text!)
    }
}

extension UITextView
{
    func isEmptyOrWhitespace() -> Bool {
        if(self.text!.isEmpty) {
            return true
        }
        return (self.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
    }
}

extension UILabel
{
    func isEmptyOrWhitespace() -> Bool {
        if(self.text!.isEmpty) {
            return true
        }
        return (self.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "")
    }
}

extension String
{
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trimCharactersFromString(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
    
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        return dateFormatter.string(from: dt ?? Date())
    }
}

extension UIButton
{
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

extension UIColor
{
    static let boarderColor = UIColor(red: 125 / 255, green: 125 / 255, blue: 125/255, alpha: 1)
}
