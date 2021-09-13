//
//  FilterVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol FilterData:class {
    func filterData(distance:String,date:String)
}
class FilterVC : CustomViewController {
    
    @IBOutlet weak var distance:UISlider!
    @IBOutlet weak var txt_Date : UITextField!
    @IBOutlet weak var txt_Time : UITextField!
    @IBOutlet weak var lbl_Distance : UILabel!
    
    var picker:UIDatePicker!
    var toolBar:UIToolbar!
    var fieldTag:Int?
    var pickedDistance:String?

    weak var delegate : FilterData?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.distance.addTarget(self, action: #selector(pickDistance(sender:)), for: .valueChanged)
        self.txt_Date.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_Time.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
    }
    @objc func pickDistance(sender:UISlider){
        pickedDistance="\(Int(sender.value))"
        lbl_Distance.text = "\(Int(sender.value)) miles"
    }
    @objc func callDatePicker(field:UITextField)
    {
        if picker != nil{
            self.picker.removeFromSuperview()
            self.picker = nil
        }
        if toolBar != nil{
            self.toolBar.removeFromSuperview()
            self.toolBar = nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        switch field.tag  {
        case 10:
            picker=UIDatePicker()
            if #available(iOS 13.4, *) {
                picker.preferredDatePickerStyle = .wheels
                
            }
            picker.datePickerMode = .date
            picker.minimumDate = Date()
            txt_Date.inputView = picker
            txt_Date.inputAccessoryView = createToolBar()
            fieldTag = field.tag
        
        case 20:
            if txt_Date.text?.isEmpty ?? false
            {
                self.view.makeToast("First pick date", duration: 1, position: .center)
                txt_Date.resignFirstResponder()
                break
            }
            else
            {
                picker=UIDatePicker()
                if #available(iOS 13.4, *) {
                    picker.preferredDatePickerStyle = .wheels
                }
                picker.datePickerMode = .time
                if txt_Date.text == currentDate{
                    picker.minimumDate = Date()
                }
                txt_Time.inputView = picker
                txt_Time.inputAccessoryView = createToolBar()
                fieldTag = field.tag
            }
       
        default:
            return
        }
    }
    func createToolBar()->UIToolbar
    {
        //Tool bar
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        //Bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: false)
        return toolBar
    }
    @objc func donePressed()
    {
        let dateFormatter=DateFormatter()
        switch fieldTag {
        case 10:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: picker.date)
            self.txt_Date.text = dateString
            self.txt_Time.text?.removeAll()
            self.view.endEditing(true)
    
        case 20:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.txt_Time.text = dateString
            self.view.endEditing(true)
    
        default:
            return
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    // MARK: - --- Action ----
    @IBAction func btn_Cancel(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Apply(_ sender:UIButton) {
        if pickedDistance == nil{
            self.view.makeToast("Pick Distance", duration: 1, position: .bottom)
        }
        else if txt_Date.text?.isEmpty ?? false{
            self.view.makeToast("Pick Date", duration: 1, position: .bottom)
        }
        else if txt_Time.text?.isEmpty ?? false{
            self.view.makeToast("Pick Time", duration: 1, position: .bottom)
        }
        else{
            var completedDate = (txt_Date.text ?? "") + " " + (txt_Time.text ?? "")
            completedDate = completedDate.localToUTC(incomingFormat: "yyyy-MM-dd hh:mm a", outGoingFormat: "yyyy-MM-dd HH:mm:ss")

            self.dismiss(animated: true, completion: nil)
            delegate?.filterData(distance: pickedDistance ?? "", date: completedDate)
        }
    }
}
