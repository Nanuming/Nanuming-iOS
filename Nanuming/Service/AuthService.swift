//
//  AuthService.swift
//  Nanuming
//
//  Created by 가은 on 2/12/24.
//

import Foundation
import GoogleSignIn
import SwiftUI
import KeychainSwift

class AuthService {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    var entryView = EntryView()
    
    // 로그인 
    func signIn(completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseUrl)/auth/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        let requestData = ["idToken": keychain.get("idToken") ?? "nil idToken"]
        
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
                let response = try JSONDecoder().decode(BaseResponse<MemberData>.self, from: data)
                if response.success {
                    // 앱 자체에 저장
                    UserDefaults.standard.set(response.data?.memberId, forKey: "userId")
                    UserDefaults.standard.set(response.data?.nickname, forKey: "userNickname")
                    self.keychain.set((response.data?.token?.accessToken)!, forKey: "accessToken")
                    self.keychain.set((response.data?.token?.refreshToken)!, forKey: "refreshToken")
                  
                    print("idToken: ", self.keychain.get("idToken") ?? "idToken nil")
                    
                    completion(true, "Login successful")
                } else {
                    completion(false, response.message)
                }
            } catch {
                completion(false, "LogIn: Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // 회원가입
    func signUp(nickname: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseUrl)/auth/register") else {
            completion(false, "Invalid URL")
            return
        }
        
        let requestData = [
            "idToken": keychain.get("idToken"),
            "nickname": nickname
        ]
        
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
                let response = try JSONDecoder().decode(BaseResponse<MemberData>.self, from: data)
                if response.success {
                    self.keychain.set((response.data?.token?.accessToken)!, forKey: "accessToken")
                    self.keychain.set((response.data?.token?.refreshToken)!, forKey: "refreshToken")
                    completion(true, "Login successful")
                } else {
                    completion(false, response.message)
                }
            } catch {
                completion(false, "SignUp: Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func googleLogin(completion: @escaping (Bool) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController.self else {
            completion(false)
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [self] user, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = user, let profile = user.user.profile, let idToken = user.user.idToken else {
                print("ID 토큰을 얻을 수 없습니다.")
                completion(false)
                return
            }
            
            self.keychain.set(profile.email, forKey: "email")
            self.keychain.set(idToken.tokenString, forKey: "idToken")
            
            // url to string
            if let imageUrl = profile.imageURL(withDimension: 180) {
                let urlString = imageUrl.absoluteString
                keychain.set(urlString, forKey: "profileImage")
            }
            completion(true)
        }
    }

}
