//
//  ViewController.swift
//  iPenny
//
//  Created by Dimi Barkas on 28.10.19.
//  Copyright © 2019 Dimi Barkas. All rights reserved.
//

import UIKit
import CoreBluetooth

let img = UIImage(named: "Bckgrnd50B.png")

class ViewController: UIViewController, CBPeripheralDelegate ,CBCentralManagerDelegate {

    var manager:CBCentralManager!
    var money:Double = 0
    let iPennyService = CBUUID(string: "2df15924-0c57-11ea-8d71-362b9e155667")
    var iPennyPeripharal: CBPeripheral!
    private var value : CBCharacteristic?
    var change:Double = 0
    
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var countMoneyButton: UIButton!
    @IBOutlet weak var changeMoneyButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var iPennyLabel: UILabel!
    @IBOutlet weak var myActivIndi: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myActivIndi.hidesWhenStopped = true
        
        self.view.backgroundColor = UIColor(patternImage: img!)
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.countMoneyButton.layer.cornerRadius = 20
        self.changeMoneyButton.layer.cornerRadius = 20
        self.helpButton.layer.cornerRadius = 20
        self.iPennyLabel.layer.cornerRadius = 20
        manager = CBCentralManager(delegate: self, queue: nil)
        NotificationCenter.default.addObserver(self,
                                              selector:#selector(resetCounter(notification:)),
                                               name: Notification.Name(rawValue: "resetNotification"),
                                               object: nil)
    }
    
    @IBAction func onCheckChangeMoneyClick(_ sender: Any) {
        //AlertView.instance.showAlert(alertType: .input)
        let inputAlertController = UIAlertController(title: "Betrag eingeben", message: "Bitte geben Sie den Betrag des Rückgeldes ein:", preferredStyle: .alert)
        inputAlertController.addTextField {(textField) in
            textField.placeholder = "Betrag in €"
            textField.keyboardType = .decimalPad
        }
        
        inputAlertController.addAction(UIAlertAction(title: "OK",style: .default, handler: { [weak inputAlertController] (_) in
            let textField = inputAlertController?.textFields![0]
            let value = textField?.text
            self.change = (value! as NSString).doubleValue
            
            let x = Double(round(1000*self.change)/1000)
            
            let str = String(format: "Dir fehlen %.\(2)f",x) + String ("€")
                       NotificationCenter.default.post(name: Notification.Name(rawValue: "changeNotification"),
                                                       object: nil,
                                                       userInfo: ["message": str])
            
            self.showNextView()
            }))
        
        inputAlertController.addAction(UIAlertAction(title: "Löschen", style: .destructive,handler: { [weak inputAlertController] (_) in
            let textField = inputAlertController?.textFields![0]
            textField?.text = ""
        }))
        
        
        present(inputAlertController,animated: true, completion: nil)
        
    }
    
    func showNextView() {
        performSegue(withIdentifier: "rueckgeldPruefen", sender: self)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral: \(peripheral)")
        
        manager.stopScan()
        iPennyPeripharal = peripheral
        iPennyPeripharal.delegate = self
        manager.connect(iPennyPeripharal, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
                    self.myActivIndi.startAnimating()
                    self.connectionLabel.text = "Nicht verbunden"
                    self.connectionLabel.textColor = UIColor.red
                    viewDidLoad()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                //if service.uuid == iPennyService {
                    print("Penny Service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(nil, for: service)
                    return
            //    }
            }
        }
    }
   
    // Handling discovery of characteristics
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                   // if characteristic.uuid == iPennyService {
                        print("iPenny Characteristic found")
                    self.connectionLabel.text = "Verbunden"
                    self.connectionLabel.textColor = UIColor.green
                    self.myActivIndi.stopAnimating()
                    peripheral.setNotifyValue(true, for: characteristic)
                    //}
                }
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //var characteristicData = characteristic.value
        //var byte = characteristicData
        
        let value = [UInt8](characteristic.value!)

        
        //print(value[0])
        countMoney(coinValue:value[0])
        
        
        
    }
    
    
    func setNotifyValue(_ enabled: Bool,
    for characteristic: CBCharacteristic)
    {
        print("Notify")
    }
    
   
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
                
        var consoleMsg = ""
        switch (central.state) {
        case .poweredOff:
            consoleMsg = "BLE is powered off"
        case .poweredOn:
            consoleMsg = "BLE is powered on"
            manager.scanForPeripherals(withServices: [iPennyService])
        case .resetting:
            consoleMsg = "BLE is resetting"
        case .unauthorized:
            consoleMsg = "BLE is unauthorized"
        case .unknown:
            consoleMsg = "BLE is unkown"
        case.unsupported:
            consoleMsg = "BLE is unsupported"
        default:
            consoleMsg = "This shouldn't have happened"
        }
        
        print("\(consoleMsg)")
    }
    
    @ objc func resetCounter(notification: Notification) {
        if notification.userInfo != nil {
            money = 0
        }
       
    }

    
    // Service UUID
    // Object Size org.bluetooth.characteristic.object_size 0x2AC0 GSS
    func countMoney(coinValue:UInt8){
        switch (coinValue){
        //Nothing found
        case 0:
            print("keine muenze")
            // 1ct
        case 1:
                money = money + 0.01
            // 2ct
            case 2:
                money = money + 0.02
            // 5ct
            case 3:
                money = money + 0.05
            // 10ct
            case 4:
                money = money + 0.1
            // 20ct
            case 5:
                money = money + 0.2
            // 50ct
            case 6:
                money = money + 0.5
            // 1 euro
            case 7:
                money = money + 1
            // 2euro
            case 8:
                money = money + 2
            default:
            print("nicht definiert")
        }
        print(money)
        
        let x = Double(round(1000*money)/1000)
        
        let str = String(format: "%.\(2)f",x) + String ("€")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotification"),
                                        object: nil,
                                        userInfo: ["message": str])
    }
    
    

}

