//
//  AlertView.swift
//  iPenny
//
//  Created by Dimi Barkas on 10.02.20.
//  Copyright © 2020 Dimi Barkas. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        alertView.layer.cornerRadius = 10
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    enum alertType {
        case succes
        case input
    }
    
    func showAlert(alertType: alertType) {
        switch alertType {
        case .succes:
            img.image = UIImage(named: "Haken")
            self.label.text = "Ihr Rückgeld ist passend"
            self.textField.isHidden = true
        case .input:
            img.image = UIImage(named: "Eingabe")
            self.label.text = "Bitte geben Sie einen Betrag ein"
            self.textField.isHidden = true
        }
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
}
