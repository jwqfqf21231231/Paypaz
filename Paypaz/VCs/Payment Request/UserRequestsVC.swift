//
//  PaymentRequestsVC.swift
//  Paypaz
//
//  Created by MAC on 19/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class UserRequestsVC: UIViewController {
    
    @IBOutlet weak var userRequestTableView : UITableView!
    {
        didSet{
            userRequestTableView.delegate = self
            userRequestTableView.dataSource = self
            userRequestTableView.separatorStyle = .none
        }
    }
    var userID : String?
    private let dataSource = UserRequestDataModel()
    var userRequest = [UserRequests]()
    var newUserRequest = [UserRequests]()
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        Connection.svprogressHudShow(view: self)
        dataSource.delegate = self
        dataSource.pageNo = "0"
        dataSource.getPaymentRequests()
        userID = UserDefaults.standard.getUserID()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if currentPage*10 == self.userRequest.count{
                Connection.svprogressHudShow(view: self)
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getPaymentRequests()
            }
        }
    }
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension UserRequestsVC : UserRequestDelegate{
    func didRecieveDataUpdate(data: UserRequestModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if currentPage-1 != 0{
                self.newUserRequest = data.data ?? []
                self.userRequest.append(contentsOf: self.newUserRequest)
            }
            else{
                self.userRequest = data.data ?? []
            }
            userRequestTableView.reloadData()
        }
        else
        {
            if data.message == "Data not found" && currentPage-1 >= 1{
                print("No data at page No : \(currentPage-1)")
                currentPage = currentPage-1
            }
            else if data.message == "Data not found" && currentPage-1 == 0{
                self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                self.userRequest = []
            }
            else{
                self.view.makeToast(data.message ?? "", duration: 3, position: .center)
            }
            userRequestTableView.reloadData()
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
extension UserRequestsVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension UserRequestsVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserRequestsCell", for: indexPath) as? UserRequestsCell else {return UserRequestsCell()}
        
        cell.numberLabel.text = "+" + (userRequest[indexPath.row].phoneCode ?? "") + " " + (userRequest[indexPath.row].phoneNumber ?? "")
        cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .USERIMAGE)
        cell.userImage.sd_setImage(with: URL(string: url+(userRequest[indexPath.row].userProfile ?? "")), placeholderImage: UIImage(named: "place_holder"))
        cell.amountLabel.text = "$\(((userRequest[indexPath.row].amount ?? "") as NSString?)?.integerValue ?? 0)"
        cell.nameLabel.text = (userRequest[indexPath.row].firstName ?? "") + " " + (userRequest[indexPath.row].lastName ?? "")
        
        if userRequest[indexPath.row].status == "0"{
            if userRequest[indexPath.row].senderID == userID {
                cell.payAmountButton.setTitle("Money Request Sent", for: .normal)
                cell.payAmountButton.backgroundColor = UIColor(red )
                cell.isUserInteractionEnabled = true
            }
            else{
                cell.payAmountButton.setTitle("Pay Money", for: .normal)
                cell.payAmountButton.backgroundColor = .blue
                cell.isUserInteractionEnabled = false
            }
            cell.payAmountButton.setImage(nil, for: .normal)
        }
        else{
            if userRequest[indexPath.row].senderID == userID {
                cell.payAmountButton.setTitle("Money Received", for: .normal)
            }
            else{
                cell.payAmountButton.setTitle("Money Sent", for: .normal)
            }
            cell.payAmountButton.backgroundColor = UIColor(named:"GreenColor")
            cell.payAmountButton.setImage(UIImage(named:"tick_white"), for: .normal)
            cell.isUserInteractionEnabled = false
        }
        cell.payAmountButton.tag = ((userRequest[indexPath.row].id ?? "") as NSString).integerValue
        cell.payAmountButton.addTarget(self, action: #selector(payAction(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func payAction(_ sender : UIButton){
        if let vc = self.pushVC("RequestPayAmountVC") as? RequestPayAmountVC{
            print("")
        }
    }
}
