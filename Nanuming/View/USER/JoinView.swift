//
//  JoinView.swift
//  Nanuming
//
//  Created by byeoungjik on 2/10/24.
//

import SwiftUI

struct JoinView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var userData : UserData
    @State private var nickName: String = ""
    var body: some View {
        VStack (alignment: .leading) {
            Text("닉네임을 입력해주세요")
                .font(.system(size: 23, weight: .semibold))
            TextField("닉네임 입력", text: $nickName)
                            .padding()
        }
        .padding()
        
        VStack {
            Button(action: {
                userData.nickname = nickName
                // 서버의 로그인 API 엔드포인트 URL
                
                guard let url = URL(string: "https://nanuming-server-zbhphligbq-du.a.run.appapi/auth/register") else {
                        print("Invalid URL")
                        return
                    }
                
                    // HTTP 요청을 구성
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    // 전송할 데이터를 JSON 형식으로 인코딩
                let body: [String: Any] = ["idToken": userData.IDToken, "nickname": userData.nickname]
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
                    
                    // URLSession을 사용하여 HTTP POST 요청 실행
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        // 네트워크 요청 완료 후 처리
                    if let error = error {
                            print("Request error:", error)
                            return
                    }
                        
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        print("Unexpected response status code")
                        return
                    }
                        
                    if let data = data, let responseData = String(data: data, encoding: .utf8) {
                        print("Server response:", responseData)
                    }
                }
                    
                    // 네트워크 요청 시작
                task.resume()
                
            }) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: screenWidth*0.85, height: 50)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                    .overlay() {
                        Text("회원가입하기")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .semibold))
                    }
            }
        }
    }
}

#Preview {
    JoinView(userData: .constant(UserData(email: "", IDToken: "", picture: nil)))
}
