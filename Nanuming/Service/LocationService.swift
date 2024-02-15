//
//  LocationService.swift
//  Nanuming
//
//  Created by 가은 on 2/15/24.
//

import Alamofire
import Foundation
import KeychainSwift

class LocationService {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"

    // 주변 거점의 모든 물품 확인
    func getPostList(_ latitude: Double, _ longitude: Double, _ latitudeDelta: Double, _ longitudeDelta: Double, completion: @escaping (_ postListByLocation: LocationWithItemOutline) -> Void) {
        let url = "\(baseUrl)/location/nearBy"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]

        let body: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "latitudeDelta": latitudeDelta,
            "longitudeDelta": longitudeDelta
        ]
        
        // Request 생성
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
        
        // responseData를 호출하면서 데이터 통신 시작
        dataRequest.responseDecodable(of: BaseResponse<LocationWithItemOutline>.self) { response in
            switch response.result {
            case .success(let response): // 성공한 경우에
                guard let result = response.data else { return }
                
                completion(result)
                
            case .failure(let error):
                print("DEBUG(get post list api) error: \(error)")
            }
        }
    }
}
