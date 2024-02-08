//
//  MapView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import GoogleMaps
import SwiftUI

struct MapView: View {
    @ObservedObject var mapVM: MapViewModel
    
    var body: some View {
        GoogleMapView(mapVM: mapVM)
    }
}

struct GoogleMapView: UIViewRepresentable {
    @ObservedObject var mapVM: MapViewModel
    
    func makeUIView(context: Context) -> GMSMapView {
        mapVM.requestLocationAuthorization()
        
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 12)
        mapView.camera = camera
        
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        print("update")
    }
}
