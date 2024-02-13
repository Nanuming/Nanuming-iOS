//
//  JoinView.swift
//  Nanuming
//
//  Created by byeoungjik on 2/10/24.
//

import SwiftUI

struct JoinView: View {
    @State private var isSignUpSuccessful = false
    @State private var message = ""
    @State private var shouldNavigate = false
    @State private var nickName: String = ""
    var body: some View {

        VStack {
        }
        .padding(60)
        VStack (alignment: .leading) {
            Text("닉네임을 입력해주세요")
                .font(.system(size: 23, weight: .semibold))
            customTextfield(placeholder: "닉네임 입력", insertText: $nickName)
            Spacer()
        }
        .navigationTitle("회원 가입")
        .foregroundStyle(Color.textBlack)
        .font(.system(size: 14, weight: .semibold))
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        
        VStack {
            Button(action: {
                // 회원가입 API
                AuthService().signUp(nickname: nickName) { success, message in
                    self.isSignUpSuccessful = success
                    self.message = message
                    if success {
                        self.shouldNavigate = true
                        print("join success: \(success)")
                    } else {
                        print(message)
                    }
                }
                
            }) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: screenWidth * 0.85, height: 50)
                    .backgroundStyle(.greenMain)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    .overlay() {
                        Text("회원가입하기")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .semibold))
                    }
            }
            .fullScreenCover(isPresented: $shouldNavigate) {
                TabBarView()
            }
        }
        .padding()
        
    }
    
    @ViewBuilder
    func customTextfield(placeholder: String, insertText: Binding<String>) -> some View {
        VStack() {
            
            TextField(placeholder, text: insertText)
            
            Rectangle()
                .frame(width: screenWidth * 0.85, height: 1)
                .foregroundColor(.gray200)
        }
        .padding()
    }
}

#Preview {
    JoinView()
}
