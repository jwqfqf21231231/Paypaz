//
//  QRCodeScannerVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import AVKit

class QRCodeScannerVC : CustomViewController {
    
    @IBOutlet weak var qrScannerView : QRScannerView!
    let verifyQRCodeDataSource = VerifyContactDataModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.verifyQRCodeDataSource.delegate = self
        self.qrScannerView.delegate = self

        //        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) { [weak self] in
        //            self?.navigationController?.popViewController(animated: false)
        //           if let req_payAmountVC = self?.pushVC("RequestPayAmountVC") as? RequestPayAmountVC {
        //                req_payAmountVC.selectedPaymentType = .local
        //            }
        //}
        
    }
    
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btn_flashButon_Clicked() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch
        {
            do
            {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOn(level: 1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            }
            catch
            {
                self.showAlert(withMsg: "Error", withOKbtn: false)
            }
        }
    }
}

extension QRCodeScannerVC : VerifyContactDelegate{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let vc = self.pushVC("RequestPayAmountVC") as? RequestPayAmountVC
            {
                vc.userDetails = ["userPic":data.data?.userProfile ?? "","userName":((data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")), "phoneCode":data.data?.phoneCode ?? "", "phoneNumber":data.data?.phoneNumber ?? ""]
                vc.receiverID = data.data?.id ?? ""
                vc.selectedPaymentType = .local
                vc.scanQRCode = true
                vc.paypazUser = true
            }
        }
        else
        {
            
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
extension QRCodeScannerVC : QRScannerViewDelegate {
    func qrScanningDidFail() {
        print("faillllllll")
        self.showAlert(withMsg: "Error", withOKbtn: false)
    }
    
    func qrScanningSucceededWithCode(_ str: String?)
    {
        verifyQRCodeDataSource.userToken = str ?? ""
        verifyQRCodeDataSource.verifyContact()
    }
    
    // if let scannedVC = self.pushToVC("ScannedBatteryDetailVC") as? ScannedBatteryDetailVC {
    //     scannedVC.selectedMachineCode = str
    // }
    
    func qrScanningDidStop() {
        print("stoppped")
        //  self.showAlert(withMsg: "Stopped", withOKbtn: false)
    }
}
