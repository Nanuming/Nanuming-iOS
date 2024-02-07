//
//  MapView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import CoreLocation
import SwiftUI

struct MapView: View {

    var body: some View {
        Text("mapView")
            .onAppear {
                requestLocationAuthorization()
            }
    }
    
}

// 위치 권한 확인
func requestLocationAuthorization() {
    let locationManager = CLLocationManager()
    
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


#Preview {
    MapView()
}
