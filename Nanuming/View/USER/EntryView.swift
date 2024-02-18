//
//  EntryView.swift
//  Nanuming
//
//  Created by 가은 on 1/28/24.
//

import Foundation
import SwiftUI
import GoogleSignInSwift

var screenWidth = UIScreen.main.bounds.size.width
var screenHeight = UIScreen.main.bounds.size.height

struct EntryView: View {
    
    @State private var isAlert = false
    @State private var message = ""
    @State private var nextView: Int = 1
    @State private var isSignInSuccessful = false
    
    public init() {
        let appearance = UINavigationBarAppearance()
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.textBlack]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.textBlack]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: screenWidth * 0.7,height: screenWidth * 0.65)
            ZStack {
                GoogleSignInButton(
                    scheme: .light,
                    style: .wide,
                    action: {
                        AuthService().googleLogin { success in
                            if success {
                                // 로그인 API
                                AuthService().signIn() { success, message in
                                    self.message = message
                                    if success {
                                        nextView = 1
                                        isSignInSuccessful = true
                                        print("success: \(success), message: \(message)")
                                    } else {
                                        nextView = 2
                                        isSignInSuccessful = true
                                        print("success: \(success), message: \(message)")
                                    }
                                }
                            } else {
                                self.isAlert = true
                            }
                        }
                    }
                )
                
                .frame(width: screenWidth*0.85, height: 50, alignment: .center)
            }
        }
        .alert(LocalizedStringKey("Failed Login"), isPresented: $isAlert) {
            Button(action: {
                isAlert = false
            }, label: {
                Text("OK")
            })
        } message: {
            Text("please try again.")
        }
        .fullScreenCover(isPresented: $isSignInSuccessful) {
            if nextView == 1 {
                TabBarView()
            } else if nextView == 2 {
                JoinView()
            }
        }
        .onChange(of: nextView, initial: false) { newValue, _ in
            if newValue == 1 {
                print("tabBarView")
            } else if newValue == 2 {
                print("JoinView")
            }
        }
    }
    
    #Preview {
        EntryView()
    }
}
