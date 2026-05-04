//
//  ContentView.swift
//  CoreBluetoothX
//
//  Created by Cepheus on 04/05/26.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
	
	@StateObject private var bluetoothManager = BluetoothManager()
	
    var body: some View {
		ZStack {
			List {
				ForEach(Array(bluetoothManager.connectedDevices), id: \.identifier) { device in
					Text(device.description)
				}
			}
			.overlay(content: {
				if bluetoothManager.connectedDevices.isEmpty {
					ContentUnavailableView("No Bluetooth Device found", systemImage: "dot.radiowaves.left.and.right")
				}
			})
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Toggle("Toggle Bluetooth", isOn: .init(get: {
						bluetoothManager.isBluetoothOn
					}, set: { newValue in
						if newValue != bluetoothManager.isBluetoothOn {
							self.bluetoothManager.toggleConnection()
						}
					}))
				}
			}
		}
    }
}
