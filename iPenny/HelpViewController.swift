//
//  HelpViewController.swift
//  iPenny
//
//  Created by Dimi Barkas on 11.02.20.
//  Copyright © 2020 Dimi Barkas. All rights reserved.
//

import Foundation
import UIKit


class HelpViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: img!)
        self.label.layer.cornerRadius = 20

    }
    
}
