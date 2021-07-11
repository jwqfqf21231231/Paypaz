//
//  EventDetailVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

extension EventDetailVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView.tag == 10 {
            return 5
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
            else { return ProductCell() }
        
        if collectionView.tag == 10 && indexPath.row == 4 {
             guard let more_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePeopleCell", for: indexPath) as? MorePeopleCell
             else { return MorePeopleCell() }
            return more_cell
         }
        return cell
    }
    
    
}
extension EventDetailVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 10 {
            let height = collectionView.frame.size.height
            
            return CGSize(width: height, height: height)
        } else {
            let width = UIScreen.main.bounds.width
            
            return CGSize(width: width * 0.5, height: collectionView.frame.size.height)
        }
         
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView.tag == 10  {
            if indexPath.row == 4 {
                if let _ = self.presentPopUpVC("InvitedPeopleVC", animated: false) as? InvitedPeopleVC {
                    
                }
            }else {
                _ = self.pushToVC("OtherUserProfileVC")
            }
            
         }  else if collectionView.tag != 10{
            _ = self.pushToVC("ProductDetailVC")
        }
        
    }
}

