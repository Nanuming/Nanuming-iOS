//
//  EntryView.swift
//  Nanuming
//
//  Created by 가은 on 1/28/24.
//

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
                    .frame(width: screenWidth*0.7,height: screenWidth*0.65)
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
                    TabBarView(userData: $userData)
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
                let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
                userData = data
                isLogined = true
                print(isLogined)
            }
        }
    }
    func googleLogin() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController.self else { return }
        print("presentingViewController: \(presentingViewController)")
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) {
//            signInResult, error in guard let result = signInResult else {
//                if let signInError = error {
//                    print("Login error: \(signInError.localizedDescription)")
//                    isAlert = true
//                }
//                return
//            }
//            guard let profile = result.user.profile else { return }
//            let data = UserData(url: profile.imageURL(withDimension: 180), name: profile.name, email: profile.email)
//            userData = data
//            isLogined = true
//            print("userData: \(userData)")
//            
//        }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else {
                print("error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let signInResult = signInResult else { return }

            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else {
                    print("error")
                    return
                }
                guard let user = user else { return }

                let idToken = user.idToken
                print("idToken\(String(describing: idToken))")
                // Send ID token to backen
                tokenSignIn(idToken: "google_12345")
            }
        }
        func tokenSignIn(idToken: String) {
            guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
                return
            }
            let url = URL(string: "/api/auth/login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
                // Handle response from your backend.
                isLogined = true
            }
            task.resume()
        }
        struct userInfo {
            var success: Bool? = false
            var status: Int? = 0
            var message: String? = nil
            var data: UserData? = nil
            
        }
        struct UserData {
            var providerId: String? = nil
            var nickname: String? = nil
            var token: Token? = nil
        }
        struct Token {
            var accessToken: String? = nil
            var refreshToken: String? = nil
        }
    }
}
//private struct ViewControllerRepresentable: UIViewControllerRepresentable {
//  let viewController = UIViewController()
//
//  func makeUIViewController(context: Context) -> some UIViewController {
//    return viewController
//  }
//
//  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//}
#Preview {
    EntryView(userData: UserData(url: nil, name: "", email: ""))
}
