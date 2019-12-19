//
//  ViewController.swift
//  BatteryLevelPeripheral
//
//  Created by Vladislav Kleschenko on 12/15/19.
//  Copyright © 2019 Vladislav Kleschenko. All rights reserved.
//

import UIKit
import CoreBluetooth

final class ViewController: UIViewController {

    @IBOutlet private weak var batteryLevelLabel: UILabel!

    private let bluetoothService = BluetoothService.shared
    private let batteryService = BatteryService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        bluetoothService.requestForValue = {
            Int(UIDevice.current.batteryLevel * 100)
        }
        batteryService.batteryLevelDidUpdate = { [weak self] newValue in
            self?.set(batteryLevel: newValue)
        }
        set(batteryLevel: batteryService.batteryLevel)
    }

    private func set(batteryLevel: Int) {
        bluetoothService.send(newValue: batteryLevel)
        batteryLevelLabel.text = "\(batteryLevel) %"
    }
}

