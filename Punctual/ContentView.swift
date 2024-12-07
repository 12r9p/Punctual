//
//  ContentView.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isHalfModalPresented = true // 常にモーダルを表示
    @State private var slVal : Double = 0
    @State private var isRoute: Bool = false
    @State private var isRun: Bool = false

    var body: some View {
        ZStack {
            Map()
            VStack{
                Button("ハーフモーダルを表示") {
                    isHalfModalPresented = true
                }
            }
        }
        
        .sheet(isPresented: $isHalfModalPresented) {
        HalfModalView()
                .presentationDetents([.height(100), .medium, .large]) // デフォルトは小さいサイズ
                .presentationDragIndicator(.visible) // ドラッグインジケータを表示
                .presentationBackgroundInteraction(.enabled(upThrough: .height(100)))
        }
        if isRoute {
            
        }
        if isRun {
            
        }
    }
}

struct HalfModalView: View {
    @State private var slVal : Double = 0
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("ハーフモーダル")
                    .font(.headline)

                Slider(value: $slVal, in: 0...10, step: 1)
                            Text("\(slVal)")

                ForEach(0..<30, id: \.self) { i in
                    Text("項目 \(i + 1)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
