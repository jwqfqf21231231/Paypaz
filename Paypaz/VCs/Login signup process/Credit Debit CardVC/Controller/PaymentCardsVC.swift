//
//  PaymentCardsVC.swift
//  Paypaz
//
//  Created by MAC on 28/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class PaymentCardsVC: UIViewController {
    
    var cards = [String]()
    @IBOutlet weak var tableView_AddCards       : UITableView!{
        didSet{
            tableView_AddCards.dataSource = self
            tableView_AddCards.delegate   = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_addPaymentCards(_ sender:UIButton)
    {
        if let addProduct = self.presentPopUpVC("CreditDebitCardVC", animated: false) as? CreditDebitCardVC {
            //            addProduct.eventID = eventID
            //            addProduct.callback = { [self] item in
            //                self.productArr.append(["image" : item["productImage"]!,"price" : item["productPrice"]!,"name" : item["productName"]!,"description" : item["productDescription"]!,"isPaid" :item["isPaid"]!,"fromServer" : false])
            //
            //                self.productIDArr.append(item["productID"] as! String)
            //                DispatchQueue.main.async {
            //                    if self.isEdit ?? false{
            //                        self.btn_Submit.setTitle("Done", for: .normal)
            //                    }
            //                    else{
            //                        self.btn_Submit.setTitle("Continue", for: .normal)
            //
            //                    }
            //                    self.btn_Submit.setTitleColor(.white, for: .normal)
            //                    self.btn_Submit.backgroundColor = UIColor(named: "GreenColor")
            //                    self.tableView_Products.reloadData()
        }
    }
    @IBAction func btn_Back(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
}
extension PaymentCardsVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cards.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell") as? ProductTableCell else { return ProductTableCell() }
        
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(deleteProduct(button:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteProduct(button : UIButton)
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteEventPopupVC") as? DeleteEventPopupVC{
           
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
