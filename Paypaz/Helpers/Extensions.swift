//
//  Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Network
import DropDown

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
    
    func pushToVC (_ identifier : String, animated:Bool = true) -> UIViewController{
 
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
            field.border_Color = UIColor(named: "SkyblueColor")//UIColor.red
        }
      //  textField.layer.borderColor = UIColor.red.cgColor
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
                //UIColor.lightGray.withAlphaComponent(0.65)
                //UIColor(red: 0.93, green: 0.95, blue: 1.00, alpha: 1.00)
            }
        }
    }
}
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
//MARK:- ----
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
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
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
