//
//  PaymentRequestsVC.swift
//  Paypaz
//
//  Created by MAC on 19/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class UserRequestsVC: UIViewController {
    
    @IBOutlet weak var userRequestTableView : UITableView!
    private let dataSource = UserRequestDataModel()
    var userRequest = [UserRequests](){
        didSet{
            userRequestTableView.reloadData()
        }
    }
    var newUserRequest = [UserRequests]()
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        dataSource.pageNo = "0"
        dataSource.getPaymentRequests()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as? TransactionsCell else {return TransactionsCell()}
        return cell
    }
}
