//
//  mapView.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//
import SwiftUI
import MapKit

struct MapView: View {
    @Binding var isSelect: Bool
    @Binding var isRoute: Bool
    @Binding var isRun: Bool
    @Binding var isFinish: Bool
    @Binding var degub: Bool
    
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917), // 初期座標: 東京
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)
        
    var body: some View {
        VStack{
            if degub{
                Toggle("Select", isOn: $isSelect)
                Toggle("Route", isOn: $isRoute)
                Toggle("Run", isOn: $isRun)
                Toggle("Finish", isOn: $isFinish)
            }
            if isSelect && !isRoute && !isRun && !isFinish{
                ZStack {
                    // 地図
                    Map(coordinateRegion: $region, interactionModes: .all)
                        .ignoresSafeArea()
                    
                    // 画面中央のピン
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                        .offset(y: -20) // ピンの位置調整
                    
                    // 座標を表示するラベル
                    VStack {
                        
                        Text("緯度: \(region.center.latitude), 経度: \(region.center.longitude)")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding()
                        Spacer()
                    }
                }
                
            }
            else if isRoute{
                Map()
            }
        }
        
    }
}

#Preview {
    @State var isSelect: Bool = true
    @State var isRoute: Bool = false
    @State var isRun: Bool = false
    @State var isFinish: Bool = false
    @State var debug: Bool = true
    MapView(isSelect: $isSelect, isRoute: $isRoute, isRun: $isRun, isFinish: $isFinish, degub: $debug)
}
