//
//  CoreBluetooth.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 16/11/20.
//


import Foundation
import CoreBluetooth
 
class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
 
    var myCentral: CBCentralManager!
 
    @Published var isSwitchedOn = false
 
    override init() {
        super.init()
 
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
 
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
}
