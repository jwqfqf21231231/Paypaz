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

    //MARK:-
    @IBOutlet weak var qrScannerView : QRScannerView!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.qrScannerView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) { [weak self] in
           if let req_payAmountVC = self?.pushToVC("RequestPayAmountVC") as? RequestPayAmountVC {
                req_payAmountVC.selectedPaymentType = .local
            }
        }
        
    }
    //MARK:-
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_flashButon_Clicked() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
        do {
            try device.lockForConfiguration()
            let torchOn = !device.isTorchActive
            try device.setTorchModeOn(level: 1.0)
            device.torchMode = torchOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            self.showAlert(withMsg: "Error", withOKbtn: false)
        }
    }
    }
    
}

extension QRCodeScannerVC : QRScannerViewDelegate {
    func qrScanningDidFail() {
        print("faillllllll")
        self.showAlert(withMsg: "Error", withOKbtn: false)
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
     
//        if let scannedVC = self.pushToVC("ScannedBatteryDetailVC") as? ScannedBatteryDetailVC {
//            scannedVC.selectedMachineCode = str
//        }
    }
    
    func qrScanningDidStop() {
        print("stoppped")
      //  self.showAlert(withMsg: "Stopped", withOKbtn: false)
    }
    
    
}
