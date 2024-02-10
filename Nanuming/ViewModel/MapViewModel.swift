//
//  MapViewModel.swift
//  Nanuming
//
//  Created by 가은 on 2/8/24.
//

import CoreLocation
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.566535, longitude: 126.9779692)
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.startUpdatingLocation() // 위치 업데이트
        requestLocationAuthorization()
    }
    
    // 위치 권한 확인
    func requestLocationAuthorization() {
        
        // 위치 사용 권한 거부된 상태
        if locationManager.authorizationStatus == .denied {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        // 위치 사용 권한 대기 상태
        else if locationManager.authorizationStatus == .restricted || locationManager.authorizationStatus == .notDetermined {
            // 권한 요청
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 가장 최근의 위치 정보 가져오기
            if let location = locations.last {
                // 사용자 위치 업데이트
                userLocation = location.coordinate
                print("사용자 위치", userLocation)
            }
    }
}
