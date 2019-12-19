//
//  BluetoothService.swift
//  BatteryLevelPeripheral
//
//  Created by Vladislav Kleschenko on 12/15/19.
//  Copyright © 2019 Vladislav Kleschenko. All rights reserved.
//

import Foundation
import CoreBluetooth

final class BluetoothService: NSObject {

    static let shared = BluetoothService()

    private var peripheralManager: CBPeripheralManager!

    private let myServiceUUID = CBUUID(string: "5FC769E5-2532-4EB2-9FBD-DF419466C2B2")
    private let myCharasteristicUUID = CBUUID(string: "5E6BC5A4-AC32-41D7-8804-A43BAD288457")

    private var myService: CBMutableService!
    private var myCharacteristic: CBMutableCharacteristic!

    var requestForValue: () -> Int = { -1 }

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: .main, options: [CBPeripheralManagerOptionRestoreIdentifierKey: "MyPeripheral"])
        myCharacteristic = CBMutableCharacteristic(type: myCharasteristicUUID, properties: [.notify, .read], value: nil, permissions: [.readable])
        myService = CBMutableService(type: myServiceUUID, primary: true)
        myService.characteristics = [myCharacteristic]
    }

    func send(newValue: Int) {
        let data = encode(value: newValue)
        peripheralManager.updateValue(data, for: myCharacteristic, onSubscribedCentrals: nil)
    }

    private func encode(value: Int) -> Data {
        var byte = value
        return Data(bytes: &byte, count: 1)
    }
}

extension BluetoothService: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState: \(String(describing: peripheral.state.rawValue))")
        if peripheral.state == .poweredOn {
            peripheralManager.add(myService)
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [myServiceUUID]])
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("didReceiveRead request from: \(request.central.identifier)")
        request.value = encode(value: requestForValue())
        peripheral.respond(to: request, withResult: .success)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        print("State was restored")
    }
}
