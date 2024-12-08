//
//  state.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//
import Foundation
import CoreLocation
import SwiftUI
import MapKit

class State: ObservableObject {
    @Published var debug: Bool = true
    //other state
    @Published  var calendar = Calendar(identifier: .gregorian)

    //modal state
    @Published var isSelect: Bool = true
    @Published var isRoute: Bool = false
    @Published var isRun: Bool = false
    @Published var isFinish: Bool = false

    //route state
    @Published var turgetLocation: CLLocationCoordinate2D = .init()
    @Published var totalDistance: Double = 0
    
    
    
    //running state
    @Published var targetTime: Date = .init()
    @Published var needSpeed: Double = 0
    @Published var speedDifference: Double = 0
    @Published var remainingTime: TimeInterval = 0
//    @Published var speed: Double = 0
    @Published var remainingDistance: Double = 0
    
    //map
    
    //isSelect
    @Published var region : MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6813, longitude: 139.7659), // 初期座標: 東京
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)
    
    //LocationManeger
    @Published var location: CLLocation? = nil
    @Published var locationError: String? = nil
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var locations: [CLLocationCoordinate2D] = []
    
    @Published var position: MapCameraPosition = .automatic
    
    @Published var speeds: [CLLocationSpeed] = []  // 速度の履歴
    @Published var speed: CLLocationSpeed? = 0
    @Published var DoubleSpeed: Double? = 0
    @Published var locationManager = CLLocationManager()
    
}

