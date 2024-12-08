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
    
    
    var body: some View {
        if state.isSelect && !state.isRoute && !state.isRun && !state.isFinish{
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
        else if state.isRoute{
            Map()
        }
        else if state.isRun{
            ZStack {
                polylineMap()
                // 速度情報を表示する UI
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Text("現在の速度")
                            .font(.headline)
                        
                        if let speed = state.speed, speed >= 0 {
                            Text("\(speed * 3.6, specifier: "%.1f") km/h") // m/s を km/h に変換
                                .font(.largeTitle)
                        } else {
                            Text("-- km/h")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
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
