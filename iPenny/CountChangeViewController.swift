//
//  CountChangeViewController.swift
//  iPenny
//
//  Created by Dimi Barkas on 10.02.20.
//  Copyright © 2020 Dimi Barkas. All rights reserved.
//

import Foundation
import UIKit

class CountChangeViewController: UIViewController {
    
    @IBOutlet weak var changeCounter: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                            selector:#selector(ShowChangeRecieved(notification:)),
                                               name: Notification.Name(rawValue: "changeNotification"),
                                               object: nil)
        self.view.backgroundColor = UIColor(patternImage: img!)
        self.changeCounter.layer.cornerRadius = 20

    }
    
    @objc func ShowChangeRecieved(notification: Notification) {
        if let message = notification.userInfo {
            if let msg = message["message"] as? String {
                self.changeLabel.text = msg
            }
        }
    }
}
