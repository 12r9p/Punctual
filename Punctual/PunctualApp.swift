//
//  PunctualApp.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//

import SwiftUI
import SwiftData

@main
struct PunctualApp: App {
    @StateObject private var state = State() // 状態の初期化
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state) // 環境オブジェクトを渡す

        }
    }
}
