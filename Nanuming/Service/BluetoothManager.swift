//
//  BluetoothManager.swift
//  Nanuming
//
//  Created by byeoungjik on 2/12/24.
//

import CoreBluetooth
import Foundation

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nill baseUrl")"
    var itemId: String?
    var centralManager: CBCentralManager!
    @Published var discoveredDevices: [CBPeripheral] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("power on")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        print("power off")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            DispatchQueue.main.async {
                self.discoveredDevices.append(peripheral)
            }
        }
    }
    
    func startScanning() {
        //bluetooth on
        guard centralManager.state == .poweredOn else { return }
        //all discovered peripherals
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    func RequestBluetooth(requestData: [String: Any], completion: @escaping (Bool, String) -> Void) {
//        \(String(describing: itemId))
        guard let url = URL(string: "\(baseUrl)/api/item/1/assign") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: []) else {
            completion(false, "Invalid request data")
            return
        }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(false, "Network request failed")
                return
            }
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response: \(dataString)")
            }
            do {
                let response = try JSONDecoder().decode(BaseResponse<Item>.self, from: data)
                if response.success {
                    completion(true, "open")
                } else {
                    completion(false, response.message)
                }
            } catch {
                completion(false, "Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }
}
