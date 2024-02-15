//
//  PairingNanumBox.swift
//  Nanuming
//
//  Created by byeoungjik on 2/12/24.
//

import SwiftUI
import CoreBluetooth

struct ConnectBoxView: View {
    
    @ObservedObject var bluetoothManager = BluetoothManager()
    @State private var identifyingNumber: String = ""
    var itemId: String = "1"
    var body: some View {
        NavigationStack {
            VStack {
                //고유번호 입력
                Text("고유 번호를 입력해주세요.")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.textBlack)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray300, lineWidth: 2.0)
                    .frame(width: screenWidth * 0.85, height: 43)
                    .overlay(alignment: .center, content: {
                        TextField(text: $identifyingNumber, label: {
                            Text("나누밍 상자 고유번호 입력 ")
                        })
                        .padding()
                    })
                    .padding()
                // 페어링 버튼
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: screenWidth * 0.85, height: 43)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    .foregroundColor(.greenMain)
                    .overlay(content: {
                        Button(action: {
                            let lockerNum = ["lockerId":identifyingNumber]
                            print("identifying number: \(identifyingNumber)")
                            print("Scan: \(bluetoothManager.centralManager.isScanning)")
                            bluetoothManager.centralManagerDidUpdateState(bluetoothManager.centralManager)
                            bluetoothManager.RequestBluetooth(requestData: lockerNum, itemId: itemId) { success, message in
                                if success {
                                    self.bluetoothManager.startScanning()
                                    print("success: \(success), message: \(message)")
                                    // TODO: 상자로부터 수신한 데이터 처리 필요
                                    print("\(self.bluetoothManager.receivedDataString ?? "not recieved")")
                                } else {
                                    print("success: \(success), message: \(message)")
                                }
                            }
                        }, label: {
                            Text("확인")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        })
                    })
                    .padding()
                    .offset(y: screenHeight * 0.27)
            }
            .onDisappear {
                bluetoothManager.stopScanning()
            }
            
        }
    }
}

#Preview {
    ConnectBoxView()
}
