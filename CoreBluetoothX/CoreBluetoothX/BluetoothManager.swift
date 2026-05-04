//
//  BluetoothManager.swift
//  CoreBluetoothX
//
//  Created by Cepheus on 04/05/26.
//

import Foundation
import Combine
import CoreBluetooth


final class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
	
	@Published var bluetoothState: CBManagerState = .unknown
	var isBluetoothOn: Bool {
		bluetoothState == .poweredOn
	}
	@Published var connectedDevices: Set<CBPeripheral> = .init()
	
	
	private var manager: CBCentralManager!
	
	
	override init() {
		super.init()
		self.manager = CBCentralManager(delegate: self, queue: nil)
	}
	
	
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		self.bluetoothState = central.state
		if central.state == .poweredOn {
			central.scanForPeripherals(withServices: nil)
		}
	}
	
	func centralManager(
		_ central: CBCentralManager,
		didDiscover peripheral: CBPeripheral,
		advertisementData: [String : Any],
		rssi RSSI: NSNumber
	) {
		self.connectedDevices.insert(peripheral)
	}
	
	func toggleConnection() {
		guard manager != nil else {
			return
		}
		if self.bluetoothState == .poweredOn {
			self.manager.stopScan()
			self.connectedDevices.removeAll()
		} else {
			self.manager.scanForPeripherals(withServices: nil)
		}
	}
}
