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
    @State var placeList: [PlaceLocation]
    
    var body: some View {
        GoogleMapView(mapVM: mapVM, placeList: $placeList)
    }
}

struct GoogleMapView: UIViewRepresentable {
    @ObservedObject var mapVM: MapViewModel
    @Binding var placeList: [PlaceLocation]
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = mapVM
        
        let camera = GMSCameraPosition.camera(withLatitude: mapVM.userLocation.latitude, longitude: mapVM.userLocation.longitude, zoom: 15)
        mapView.camera = camera
        
        // 마커 업데이트
        showMarkers(on: mapView)
        
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
//        print("update")
    }
    
    func showMarkers(on mapView: GMSMapView) {
        // 기존 마커 제거
        mapView.clear()
        
        for place in placeList {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            print(place.locationId, marker.position)
            marker.title = String(place.locationId)
            marker.map = mapView
        }
    }
}
