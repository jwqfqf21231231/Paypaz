//
//  BuyEventVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 29/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension BuyEventVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BuyEventTblCell")  as? BuyEventTblCell
            else { return BuyEventTblCell() }
        
       // self.addTapGestureOnImg(cell.img_event)
        
        var sDate = filteredEventData[indexPath.row].startDate ?? ""
        sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
        cell.lbl_EventDay.text = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "d")
        cell.lbl_EventMonth.text = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "EEE")
        cell.img_event.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
        cell.img_event.sd_setImage(with: URL(string: url+(filteredEventData[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "event_img"))
        cell.txt_eventName.text = filteredEventData[indexPath.row].name
        cell.txt_personName.text = (filteredEventData[indexPath.row].firstName ?? "")+" "+(filteredEventData[indexPath.row].lastName ?? "")
        cell.txt_eventPrice.text = "$\((filteredEventData[indexPath.row].price! as NSString).integerValue)"
        cell.lbl_Distance.text = "\(filteredEventData[indexPath.row].distance ?? "") miles away"
        cell.btn_addToCart.addTarget(self, action: #selector(self.clicked_btn_addToCart(_:)), for: .touchUpInside)
        cell.btn_Buy.addTarget(self, action: #selector(self.clicked_btn_Buy(_:)), for: .touchUpInside)
        cell.btn_fav.addTarget(self, action: #selector(self.clicked_btn_Fav(_:)), for: .touchUpInside)
        cell.btn_fav.tag = Int(filteredEventData[indexPath.row].id ?? "") ?? 0
        return cell
    }
    @objc func clicked_btn_Fav(_ sender: UIButton)
    {
        dataSource.delegate1 = self
        sender.setImage(UIImage(named: "red"), for: .normal)
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = "\(sender.tag)"
        dataSource.favEvent()
    }
    private func addTapGestureOnImg(_ img:RoundImage) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clicked_img_Event(_:)))
        img.addGestureRecognizer(tap)
    }
    @objc func clicked_btn_addToCart(_ sender:RoundButton) {
        _ = self.pushVC("MyCartVC")
    }
    @objc func clicked_btn_Buy(_ sender:RoundButton) {
        if let products = self.presentPopUpVC("ProductListVC", animated: true) as? ProductListVC {
            products.delegate = self
        }
    }
    @objc func clicked_img_Event(_ sender:UITapGestureRecognizer) {
        _ = self.pushVC("EventDetailVC")
    }
}
extension BuyEventVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let vc = self.pushVC("EventDetailVC") as? EventDetailVC{
            vc.eventID = filteredEventData[indexPath.row].id ?? ""
        }
    }
}


extension BuyEventVC : PopupDelegate {

    func isClickedButton() {
        _ = self.pushVC("PayAmountVC")
    }
}
//MARK:- ---- Collection View ----
extension BuyEventVC : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCalendarDays?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return CalendarCell() }
        
        let data = self.arrCalendarDays?[indexPath.row]
        let day  = data?.components(separatedBy: " ").first
        let date = data?.components(separatedBy: " ").last
        cell.lbl_day.text  = day
        cell.lbl_date.text = date
        return cell
    }
}
extension BuyEventVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height
        return CGSize(width: h * 0.8, height: h * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = arrCalendarDays?[indexPath.row]
        let day = data?.components(separatedBy: " ").last
        Connection.svprogressHudShow(view: self)
        dataSource.isFilter = "2"
        dataSource.day = day ?? ""
        dataSource.typeID = typeID
        dataSource.filterEvents()
    }
}
