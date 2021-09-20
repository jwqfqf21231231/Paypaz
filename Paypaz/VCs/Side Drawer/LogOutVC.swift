//
//  LogOutVC.swift
//  Paypaz
//
//  Created by MAC on 20/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
protocol LoggingOut : class{
    func logOut()
}
class LogOutVC: UIViewController {
    weak var delegate : LoggingOut!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    @IBAction func action_Yes(_ sender:UIButton){
        self.dismiss(animated: false) { [weak self] in
            self?.delegate.logOut()
        }
        
    }
    @IBAction func action_No(_ sender:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
}
