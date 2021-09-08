//
//  ChooseEventVC+Extensions.swift
//  Paypaz
//
//  Created by MACOSX on 05/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

extension ChooseEventTypeVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width*(0.5)-30, height: width*(0.4))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if doBuyEvent ?? false
        {
            if let vc = pushVC("BuyEventVC") as? BuyEventVC
            {
                vc.typeID = eventData[indexPath.row].id ?? ""
            }
        }
        else
        {
            selectedEventData?(filteredEventData[indexPath.row].name ?? "",filteredEventData[indexPath.row].id ?? "")
            self.navigationController?.popViewController(animated: true)
        }        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
extension ChooseEventTypeVC:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEventData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseEventCell", for: indexPath) as? ChooseEventCell
        else { return ChooseEventCell() }
        let url =  APIList().getUrlString(url: .EVENTIMAGE)
        cell.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_EventPic.sd_setImage(with: URL(string: url+(filteredEventData[indexPath.row].icon ?? "")), placeholderImage: UIImage(named: "sports_fitness"))
      
        cell.lbl_EventName.text = filteredEventData[indexPath.row].name ?? ""
        return cell
    }
    
    
}
extension ChooseEventTypeVC : ChooseEventDataModelDelegate
{
    func didRecieveDataUpdate(data: ChooseEventModel)
    {
        print("ChooseEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            eventData = data.data ?? []
            filteredEventData = data.data ?? []
            DispatchQueue.main.async {
                self.collectionView_Events.reloadData()
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
