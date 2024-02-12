//
//  AuthService.swift
//  Nanuming
//
//  Created by 가은 on 2/12/24.
//

import Foundation

class AuthService {
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nill baseUrl")"
    
    // 로그인 
    func signIn(requestData: [String: Any], completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseUrl)/auth/login") else {
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
                let response = try JSONDecoder().decode(BaseResponse<MemberData>.self, from: data)
                if response.success {
                    completion(true, "Login successful")
                } else {
                    completion(false, response.message)
                }
            } catch {
                completion(false, "Failed to decode response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
}
