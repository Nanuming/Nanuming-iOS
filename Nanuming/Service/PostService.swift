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
    var postDetailContent: PostDetail?
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let userNickname = UserDefaults.standard.string(forKey: "userNickname")
    
    // 게시물 예비 등록
    func writePost(title: String, categoryId: Int, description: String, imageList: [Data?], completion: @escaping (_ id: Int) -> Void) {
        let url = "\(baseUrl)/item/add"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let body: [String: Any] = [
            "sharerId": userId,
            "categoryId": categoryId,
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
    func showDetail(itemId: Int, completion: @escaping (Bool, PostDetail?, String) -> Void) {
        guard let url = URL(string: "\(baseUrl)/profile/\(UserDefaults.standard.integer(forKey: "userId"))/\(itemId)") else {
            completion(false, nil, "Invalid URL")
            return
        }
        let jwtToken = keychain.get("accessToken") ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false, nil, "Network request failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BaseResponse<PostDetail>.self, from: data)
                DispatchQueue.main.async {
                    if response.success {
                        self.postDetailContent = response.data
                        print("\(self.postDetailContent?.itemId)")
                        completion(true, self.postDetailContent, "Data fetch successful")

                    } else {
                        completion(false, nil, response.message)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, nil, "Failed to decode response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func uploadImage(_ image: UIImage, itemId: Int, completion: @escaping (Bool, String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            completion(false, "Invalid Image URL")
            return
        }
        guard let url = URL(string: "\(baseUrl)/profile/\(UserDefaults.standard.integer(forKey: "userId"))/\(itemId)/confirm") else {
            completion(false, "Invalid URL")
            return
        }
        let jwtToken = keychain.get("accessToken") ?? ""
        var request = URLRequest(url: url)
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"confirmImage\"; filename=\"image\(itemId).jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false, "Network request failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BaseResponse<ImageAuth>.self, from: data)
                DispatchQueue.main.async {
                    if response.success, let ImageAuth = response.data {
                        completion(true, "Data fetch successful")
                        //                        PhotoAuthView().confirmItemImageId = ImageAuth.confirmItemImageId
                    } else {
                        completion(false, response.message)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, "Failed to decode response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    // 본인 게시물 조회
    func getMyPost(memberId: Int, status: String, completion: @escaping (_ postListByLocation: MyPostList) -> Void) {
        let query = URLQueryItem(name: "itemStatus", value: status)
        let url = "\(baseUrl)/profile/\(memberId)?\(query)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        // Request 생성
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        // responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseDecodable(of: BaseResponse<MyPostList>.self) { response in
            switch response.result {
            case .success(let response): // 성공한 경우에
                guard let result = response.data else { return }
                
                completion(result)
                
            case .failure(let error):
                print("DEBUG(get my post list api) error: \(error)")
            }
        }
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
