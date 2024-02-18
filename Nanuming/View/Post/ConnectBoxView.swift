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
    @State var isConnectedBluetooth: Bool = false
    @State var receivedData: String? = BluetoothManager().receivedDataString
    @State var isClosedBox: Bool = BluetoothManager().isClosedBox
    @State var shouldShowPhotoAuthView: Bool = false
    @State var showTabBarViewAsFullScreen: Bool = false
    @State var test: Bool = false
    var owner: Bool? = true
    var itemId: Int = 0
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
                //                List(bluetoothManager.discoveredDevices, id: \.identifier) { device in
                //                    HStack {
                //                        Text(device.name ?? "Unknown")
                //                        Spacer()
                //                        Button("Connect") {
                //                            // 해당 디바이스에 연결 시도
                //                            bluetoothManager.connectDevice(device)
                //                        }
                //                    }
                //                }
                // 페어링 버튼
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: screenWidth * 0.85, height: 43)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    .foregroundColor(.greenMain)
                    .overlay(content: {
                        Button(action: {
                            let lockerNum = ["lockerId":Int(identifyingNumber)!]
                            print("identifying number: \(identifyingNumber)")
                            print("Scan: \(bluetoothManager.centralManager.isScanning)")
                            if owner! {
                                print("nanumer\(String(describing: owner)):\(lockerNum):\(itemId)")
                                bluetoothManager.RequestNanumer(requestData: lockerNum, itemId: itemId) { success, message in
                                    if success {
                                        self.bluetoothManager.startScanning()
                                        print("success: \(success), message: \(message)")
                                        // TODO: 상자로부터 수신한 데이터 처리 필요
                                        print("\(self.bluetoothManager.receivedDataString ?? "not recieved")")
                                        test = true
                                        //                                        isConnectedBluetooth = true
                                        //                                        bluetoothManager.startScanning()
                                    } else {
                                        
                                        print("success: \(success), message: \(message)")
                                    }
                                }
                            }
                            else {
                                bluetoothManager.RequestNanumee(requestData: lockerNum) { success, message in
                                    if success {
                                        print("success: \(success), message: \(message)")
                                        // TODO: 상자로부터 수신한 데이터 처리 필요
                                        test = true
                                        isConnectedBluetooth = true
                                        self.bluetoothManager.startScanning()
                                    } else {
                                        print("success: \(success), message: \(message)")
                                    }
                                }
                            }
                            
                        }, label: {
                            Text("확인")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        })
                        .alert(LocalizedStringKey("연결중..."), isPresented: $isConnectedBluetooth) {
                            Button(action: {
                                isConnectedBluetooth = false
                            }, label: {
                                Text("취소")
                            })
                        }
                        .sheet(isPresented: $test) {
                            PhotoAuthView(itemId: itemId, memberId: UserDefaults.standard.integer(forKey: "userId"))
                        }
                        
                    })
                    .padding()
                    .offset(y: screenHeight * 0.27)
                
            }
            .onDisappear {
                bluetoothManager.stopScanning()
            }
            
        }
        //        .navigationDestination(isPresented: $test, destination: {
        //            let memberId = UserDefaults.standard.integer(forKey: "userId")
        //            PhotoAuthView(itemId: itemId, memberId: memberId)
        //        })
    }
}

#Preview {
    ConnectBoxView()
}

