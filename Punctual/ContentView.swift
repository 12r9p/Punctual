//
//  ContentView.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var state: State
    
    
    
    //    @State private var preview = RunningActivityView(
    //        targetTime: calendar.date(from: DateComponents(year: 2024, month: 12, day: 7, hour: 16, minute: 0, second: 0))!,
    //        needSpeed: 6.6,
    //        speed: 5.8,
    //        remainingDistance: 100,
    //        totalDistance: 1000
    //    )
    var body: some View {
        VStack{
            
            if state.debug{
                Toggle("Select", isOn: $state.isSelect)
                Toggle("Route", isOn: $state.isRoute)
                Toggle("Run", isOn: $state.isRun)
                Toggle("Finish", isOn: $state.isFinish)
            }
            ZStack {
                MapView()
            }
            .sheet(isPresented: $state.isSelect) {
                SelectLocationModalView()
                    .presentationBackground(.regularMaterial)
                    .cornerRadius(20)
                    .presentationDetents([.height(100), .medium,.fraction(0.9)]) // デフォルトは小さいサイズ
                    .presentationDragIndicator(.visible) // ドラッグインジケータを表示
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(100)))
                
            }
        }
    }
}

struct SelectLocationModalView: View {
    @EnvironmentObject var state: State
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("select location")
                    .font(.headline)
                Button("場所を選択"){
                    state.targetLocation = state.region.center
                    state.isRoute = true
                }
                .sheet(isPresented: $state.isRoute) {
                    routeModalView()
                        .presentationBackground(.regularMaterial)
                        .presentationDetents([.height(200)]) // デフォルトは小さいサイズ
                        .presentationDragIndicator(.visible) // ドラッグインジケータを表示
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))
                }
            }
            .padding()
            .interactiveDismissDisabled()
        }
    }
}

struct routeModalView: View {
    @EnvironmentObject var state: State
    @StateObject private var locationManager = LocationManager()

    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("select route")
                    .font(.headline)
                Button("戻る"){
                    state.isSelect = true
                    state.isRoute = false
                }
                DatePicker("ラベル", selection: $state.targetTime)
                Button("進む"){
                    state.isSelect = false
                    state.isRoute = false
                    state.isRun = true
                }
                if state.debug{
                    Text("現在地:\(locationManager.location)")
                    Text("目的地:\(state.region.center)")
                    Text ("\(state.targetTime)")
                }
            }
            .padding()
        }
    }
}



#Preview {
    @StateObject var state = State()
    ContentView().environmentObject(state)
}
