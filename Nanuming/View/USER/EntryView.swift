//
//  EntryView.swift
//  Nanuming
//
//  Created by 가은 on 1/28/24.
//
import Foundation
import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

var screenWidth = UIScreen.main.bounds.size.width
var screenHeight = UIScreen.main.bounds.size.height

struct EntryView: View {
    @State private var isLogined = false
    @State private var userData :UserData
    @State private var isAlert = false
    
    public init(isLogined: Bool = false, userData: UserData) {
        _isLogined = State(initialValue:  isLogined)
        _userData = State(initialValue:  userData)
    }
    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: screenWidth * 0.7,height: screenWidth * 0.65)
                ZStack {
                    GoogleSignInButton(
                        scheme: .light,
                        style: .wide,
                        action: {
                            googleLogin()
                        })
                    .frame(width: screenWidth*0.85, height: 50, alignment: .center)
                }
                .navigationDestination(isPresented: $isLogined, destination: {
                    JoinView(userData: $userData)
                })
                //                Button(action: {}) {
                //                    RoundedRectangle(cornerRadius: 5)
                //                        .frame(width: screenWidth*0.85, height: 50)
                //                        .foregroundColor(.white)
                //                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                //                        .overlay(
                //                            HStack {
                //                                Image("google_logo")
                //                                    .frame(width: 30, height: 30)
                //                                Text("Sign in with Google")
                //                                    .foregroundStyle(Color.textBlack)
                //                                    .font(.system(size: 17, weight: .semibold))
                //                            }
                //                        )
                //                }
                
            }
        }
        .onAppear(perform: {
            // login 상태 체크
            checkState()
        })
        .alert(LocalizedStringKey("Failed Login"), isPresented: $isAlert) {
            Button(action: {
                isAlert = false
            }, label: {
                Text("OK")
            })
        } message: {
            Text("please try again.")
        }
    }
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print("Not sign in")
            } else {
                guard let profile = user?.profile else { return }
                guard let idToken = user?.idToken else {
                        print("ID 토큰을 얻을 수 없습니다.")
                        return
                    }
                let data = UserData(email: profile.email, IDToken: idToken.tokenString, picture: profile.imageURL(withDimension: 180))
                userData = data
                isLogined = true
                print(isLogined)
            }
        }
    }
//    func decodeIDToken(idToken: GIDToken) -> String? {
//        let token = String(describing: idToken)
//        print("token \(token)")
//        let segments =  token.components(separatedBy: ".")
//        guard segments.count > 1 else { return nil }
//        
//        var base64String = segments[1]
//        // Base64 인코딩된 문자열의 길이가 4의 배수가 되도록 "=" 문자로 패딩
//        let requiredLength = 4 * ((base64String.count + 3) / 4)
//        let paddingLength = requiredLength - base64String.count
//        if paddingLength > 0 {
//            base64String += String(repeating: "=", count: paddingLength)
//        }
//        
//        guard let data = Data(base64Encoded: base64String) else { return nil }
//        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
//        
//        // 'sub' 필드 추출
//        return json["sub"] as? String
//    }
    func googleLogin() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController.self else { return }
                GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) {
                    user, error in guard let result = user else {
                        if let signInError = error {
                            print("Login error: \(signInError.localizedDescription)")
                            isAlert = true
                        }
                        return
                    }
                    guard let profile = result.user.profile else { return }
                    guard let idToken = result.user.idToken else {
                        print("ID 토큰을 얻을 수 없습니다.")
                        return
                    }
                    let data = UserData(email: profile.email, IDToken: idToken.tokenString, picture: profile.imageURL(withDimension: 180))
//                    print("GIDToken: \(data.IDToken)")
                    userData = data // userData의 상태를 업데이트합니다.
                    isLogined = true // 로그인 상태를 업데이트합니다. 해당 변수를 올바르게 관리해야 합니다.
                    
        
                }
    }
    #Preview {
        EntryView(userData: UserData(email: "", IDToken: "", picture: nil))
    }
}
