//
//  polylineMap.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/08.
//

import SwiftUI
import CoreLocation
import MapKit

struct polylineMap: View {
    @EnvironmentObject var state: State
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if !locationManager.locations.isEmpty {
                Map(position: $state.position) {
                    // 通った道を描画
                    MapPolyline(coordinates: locationManager.locations)
                        .stroke(.blue, lineWidth: 5)
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .onAppear {
                    if let firstLocation = locationManager.locations.first {
                        state.position = .region(MKCoordinateRegion(center: firstLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                        print("Map region set to first location: \(firstLocation.latitude), \(firstLocation.longitude)")
                    }
                }
            } else if let error = locationManager.locationError {
                Text("位置情報の取得に失敗しました: \(error)")
                    .foregroundColor(.red)
                    .onAppear {
                        print("Error occurred: \(error)")
                    }
            } else {
                Text("位置情報を取得中...")
                    .onAppear {
                        print("Waiting for location data...")
                    }
            }
        }
    }
}

#Preview {
    @StateObject var state = State()
    polylineMap().environmentObject(state)
}
