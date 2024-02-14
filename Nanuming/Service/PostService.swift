//
//  PostService.swift
//  Nanuming
//
//  Created by 가은 on 2/14/24.
//

import Alamofire
import Foundation
import KeychainSwift
import SwiftUI

class PostService {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let userNickname = UserDefaults.standard.string(forKey: "userNickname")

    // 게시물 예비 등록
    func writePost(title: String, description: String, imageList: [Data?], completion: @escaping (_ id: Int) -> Void) {
        let url = "\(baseUrl)/item/add"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let body: [String: Any] = [
            "sharerId": userId,
            "categoryId": 1, // TODO: 바꿔야함
            "title": title,
            "description": description
        ]

        // Multipart Form 데이터 생성
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in body {
                if let data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            for (index, imageData) in imageList.enumerated() {
                if let data = imageData {
                    multipartFormData.append(data, withName: "imageList", fileName: "image\(index + 1).png", mimeType: "image/png")
                }
            }
        }, to: url, method: .post, headers: headers)
            .responseDecodable(of: BaseResponse<PostId>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.data else { return }
                    completion(result.id)

                case .failure(let error):
                    print("DEBUG(write post api) error: \(error)")
                }
            }
    }
}
