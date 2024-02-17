//
//  BluetoothManager.swift
//  Nanuming
//
//  Created by byeoungjik on 2/12/24.
//

import CoreBluetooth
import Foundation
import KeychainSwift

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    var centralManager: CBCentralManager!
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var receivedDataString: String? = nil
    @Published var isClosedBox: Bool = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("power on")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        else if central.state == .poweredOff{
            print("power off")
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed to send 'open' command: \(error.localizedDescription)")
        } else {
            // 메시지 전송 성공 로그 출력
            print("'open' command successfully sent to nanuming device.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let deviceName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("Discovered device: \(deviceName)")
            if deviceName == "nanuming" {
                print("나누밍 상자와 연결 시도")
                central.stopScan()
                // 바로 연결 시도
                central.connect(peripheral, options: nil)
                // 추가 디바이스 검색 방지
                return
            }
        }
        
        if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            DispatchQueue.main.async {
                self.discoveredDevices.append(peripheral)
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        //모든 특성 탐색 후에 데이터 전송 가능
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        //모든 특성 탐색
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                let commandString = "open"
                if let commandData = commandString.data(using: .utf8) {
                    print("Sending 'open' command to nanuming device...")
                    peripheral.writeValue(commandData, for: characteristic, type: .withResponse)
                }
            }
        }
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error receiving notification for characteristic \(characteristic): \(error.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "nil")")
            DispatchQueue.main.async {
                self.receivedDataString = dataString
                if dataString == "closed" {
                    self.isClosedBox = true
                }
            }

        }
    }


    func startScanning() {
        //bluetooth on
        func startScanning() {
            guard centralManager.state == .poweredOn, !centralManager.isScanning else { return }
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }

    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    func RequestNanumer(requestData: [String: Any], itemId: Int, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseUrl)/profile/\(UserDefaults.standard.integer(forKey: "userId"))/\(itemId))/assign") else {
            completion(false, "Invalid URL")
            return
        }
        let jwtToken = keychain.get("accessToken") ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
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
    func RequestNanumee(requestData: [String: Any], itemId: Int, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseUrl)/locker") else {
            completion(false, "Invalid URL")
            return
        }
        let jwtToken = keychain.get("accessToken") ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
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
