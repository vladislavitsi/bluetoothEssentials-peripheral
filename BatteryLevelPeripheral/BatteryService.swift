//
//  BatteryService.swift
//  BatteryLevelPeripheral
//
//  Created by Vladislav Kleschenko on 12/15/19.
//  Copyright © 2019 Vladislav Kleschenko. All rights reserved.
//

import UIKit

final class BatteryService {

    static let shared = BatteryService()

    var batteryLevelDidUpdate: (Int) ->  () = {_ in}

    var batteryLevel: Int {
        Int(UIDevice.current.batteryLevel * 100)
    }

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateBatteryLevel), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }

    @objc private func updateBatteryLevel() {
        batteryLevelDidUpdate(batteryLevel)
    }
}
