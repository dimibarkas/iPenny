//
//  CountMoneyViewController.swift
//  iPenny
//
//  Created by Dimi Barkas on 08.01.20.
//  Copyright © 2020 Dimi Barkas. All rights reserved.
//

import Foundation
import UIKit

class CountMoneyViewController: UIViewController {
    
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBAction func resetButton(_ sender: Any) {
        self.label.text = String("0.00 €")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "resetNotification"),
                                        object: nil, userInfo: ["message": 0])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                            selector:#selector(ShowDataRecieved(notification:)),
                                               name: Notification.Name(rawValue: "myNotification"),
                                               object: nil)
        self.view.backgroundColor = UIColor(patternImage: img!)
        self.label.layer.cornerRadius = 20
        self.resetButton.layer.cornerRadius = 20
    }
    
    override func viewDidDisappear(_ animated: Bool) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "resetNotification"),
                                        object: nil, userInfo: ["message": 0])
    }
    
    @objc func ShowDataRecieved(notification: Notification) {
        if let message = notification.userInfo {
            if let msg = message["message"] as? String {
                self.label.text = msg
            }
        }
    }
    
    
    
    
}
