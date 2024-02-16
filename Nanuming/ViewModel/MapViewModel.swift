//
//  MapViewModel.swift
//  Nanuming
//
//  Created by 가은 on 2/8/24.
//

import CoreLocation
import GoogleMaps
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D = .init(latitude: 37.566535, longitude: 126.9779692)
    @Published var deltaLocation: Location = .init(latitude: 0.001, longitude: 0.001)
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 배터리에 맞게 권장되는 최적의 정확도
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
//            print("사용자 위치", userLocation)
        }
    }
    
    // 지도를 이동하다가 멈췄을 떄 호출
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // 중앙 위, 경도
        let latitude = position.target.latitude // 위도
        let longitude = position.target.longitude // 경도
        
        // 모서리 위, 경도 가져오기
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: visibleRegion)
        let northEast = bounds.northEast
        
        // 위, 경도 델타 값
        let deltaLatitude = northEast.latitude-latitude
        let deltaLongitude = northEast.longitude-longitude
        
//        print("위경도 델타 값: ", deltaLatitude, deltaLongitude)
        
        deltaLocation = Location(latitude: deltaLatitude, longitude: deltaLongitude)
        
        // 위도(latitude)와 경도(longitude)를 사용하여 원하는 작업을 수행합니다.
        // 예: 위치 기반 서비스 호출, 데이터 업데이트 등
//        print("지도 위,경도 ", latitude, longitude)
    }
    
    // 줌 변경 시 호출되는 메서드
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let currentZoom = mapView.camera.zoom
        
        // 최소 줌 배율보다 작으면 최소 줌 배율로 설정
        if currentZoom < 14 {
            mapView.animate(toZoom: 14)
        }
    }
    
    // 마커 클릭 시 동작 처리
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return true
    }
    
}
