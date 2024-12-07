//
//  ContentView.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var debug: Bool = true
    //other state
    @State private var calendar = Calendar(identifier: .gregorian)

    //modal state
    @State private var isSelect: Bool = true
    @State private var isRoute: Bool = false
    @State private var isRun: Bool = false
    @State private var isFinish: Bool = false
    
    //running state
    @State private var targetTime: Date = .init()
    @State private var needSpeed: Double = 0
    @State private var speedDifference: Double = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var speed: Double = 0
    @State private var remainingDistance: Double = 0
    
    
    //    @State private var preview = RunningActivityView(
    //        targetTime: calendar.date(from: DateComponents(year: 2024, month: 12, day: 7, hour: 16, minute: 0, second: 0))!,
    //        needSpeed: 6.6,
    //        speed: 5.8,
    //        remainingDistance: 100,
    //        totalDistance: 1000
    //    )
    
    
    var body: some View {
        ZStack {
            MapView(isSelect:$isSelect, isRoute: $isRoute, isRun: $isRun, isFinish: $isFinish, degub: $debug)
        }
        .sheet(isPresented: $isSelect) {
            SelectLocationModalView(isRoute: $isRoute,isSelect: $isSelect,isRun: isRun)
                .presentationBackground(.regularMaterial)
                .cornerRadius(20)
                .presentationDetents([.height(100), .medium,.fraction(0.9)]) // デフォルトは小さいサイズ
                .presentationDragIndicator(.visible) // ドラッグインジケータを表示
                .presentationBackgroundInteraction(.enabled(upThrough: .height(100)))
                
        }
    }
}

struct SelectLocationModalView: View {
    @Binding var isRoute: Bool
    @Binding var isSelect: Bool
    @State var isRun: Bool
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("select location")
                    .font(.headline)
                Button("場所を選択"){
                    isRoute = true
                }
                .sheet(isPresented: $isRoute) {
                    routeModalView(isSelect: $isSelect, isRoute: $isRoute, isRun: isRun)
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
    @Binding var isSelect: Bool
    @Binding var isRoute: Bool
    @State var isRun: Bool
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("select route")
                    .font(.headline)
                Button("戻る"){
                    isSelect = true
                    isRoute = false
                }
                Button("進む"){
                    isSelect = false
                    isRoute = false
                    isRun = true
                }

            }
            .padding()
        }
    }
}



#Preview {
    ContentView()
}
