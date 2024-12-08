//
//  mapView.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//
import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    @EnvironmentObject var state: State
    @StateObject private var locationManager = LocationManager()
    
    
    var body: some View {
        if state.isSelect{
            ZStack {
                // 地図
                Map(coordinateRegion: $state.region,
                    interactionModes: .all,
                    showsUserLocation: true
                    //userTrackingMode: .constant(.follow) //追跡
                )
                .mapControls {
                    MapCompass()
                        .mapControlVisibility(.visible)
                    MapPitchToggle()
                        .mapControlVisibility(.visible)
                    MapScaleView()
                        .mapControlVisibility(.hidden)
                    MapUserLocationButton()
                        .mapControlVisibility(.automatic)
                }
                .mapStyle(.standard)
                .ignoresSafeArea()
                
                // 画面中央のピン
                Image(systemName: "mappin")
                    .font(.system(size: 40))
                    .offset(y: -20) // ピンの位置調整
                
                // 座標を表示するラベル
                if state.debug{
                    VStack {
                        VStack {
                            Text("緯度: \(state.region.center.latitude), 経度: \(state.region.center.longitude)")
                        }
                        .padding()
                        .background()
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .padding()
                        Spacer()
                    }
                }
            }
        }
        else if state.isRun{
            ZStack {
                polylineMap()
                // 速度情報を表示する UI
                VStack {
                    Spacer()
                    HStack{
                        VStack{
                            Text("残り時間")
                            Text("\(state.remainingTime)")
                                .font(.headline)
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){_ in
                                        state.date = Date()
                                        let remainingTime = state.targetTime.timeIntervalSince(state.date)
                                        let seconds = Int(remainingTime) % 60
                                        let minutes = (Int(remainingTime) / 60) % 60
                                        let hours = (Int(remainingTime) / 3600) % 24
                                        let days = Int(remainingTime) / (3600 * 24)
                                        if days == 0 {
                                            state.remainingTime = String("\(hours) 時 \(minutes) 分 \(seconds) 秒")
                                        }
                                        else if hours == 0 {
                                            state.remainingTime = String("\(minutes) 分 \(seconds) 秒")
                                        }
                                        else if minutes == 0 {
                                            state.remainingTime = String("\(seconds) 秒")
                                        }
                                        state.remainingTime = String("\(days) 日 \(hours) 時 \(minutes) 分 \(seconds) 秒")
                                    }
                                    
                                }
                        }
                        VStack(spacing: 10) {
                            Text("現在の速度")
                                .font(.headline)
                            
                            if let speed = locationManager.speed, speed >= 0 {
                                Text("\(speed * 3.6, specifier: "%.1f") km/h") // m/s を km/h に変換
                                    .font(.largeTitle)
                            } else {
                                Text("-- km/h")
                                    .font(.largeTitle)
                            }
                        }
                        VStack{
                            //                        //経路探索
                            //                        //routePolyline
                            //
                            //                        if let location = locationManager.location{
                            //                            let CLLlocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            //
                            //                            let request = MKDirections.Request()
                            //                            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLlocation))
                            //                            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.targetlocation))
                            //                            request.transportType = .walking
                            //
                            //                            let directions = MKDirections(request: request)
                            //                            Task {
                            //                                do {
                            //                                    // 3)
                            //                                    let result = try await directions.calculate()
                            //                                    // 4)
                            //                                    if let route = result.routes.first {
                            //                                        let coordinateCount = route.polyline.pointCount
                            //                                        var coordinates = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: coordinateCount)
                            //                                        route.polyline.getCoordinates(&coordinates, range: NSRange(location: 0, length: coordinateCount))
                            //                                        self.routePolyline = coordinates
                            //
                            //                                        //                                   self.remainingDistance = route.distance
                            //                                    }
                            //                                } catch {
                            //                                    print(error.localizedDescription)
                            //                                }
                            //                            }
                            //
                            //                            Text("\(location.coordinate.latitude), \(location.coordinate.longitude)")
                            //                                .font(.caption)
                            //                        }
                        }
                        
                    }.padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            
        }
        else if state.isFinish{
            Map()
        }
    }
}

#Preview {
    @StateObject var state = State()
    MapView().environmentObject(state)
}
