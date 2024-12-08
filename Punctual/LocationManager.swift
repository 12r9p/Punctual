//
//  LocationManager.swift
//  run-only-run
//
//  Created by 佐藤匠 on 2024/12/06.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    @Published var locationError: String? = nil
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var locations: [CLLocationCoordinate2D] = []  // 位置情報の履歴を保持
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        // 権限のリクエスト
        locationManager.requestWhenInUseAuthorization()
        
        // 現在の権限状態を初期化
        let status = locationManager.authorizationStatus
        self.authorizationStatus = status
        print("Location authorization status: \(status)")
        
        // 位置情報の取得を開始
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            print("Authorization status changed: \(status.rawValue)")
            
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.locationManager.startUpdatingLocation()
            } else {
                self.locationError = "位置情報の権限が許可されていません。設定を確認してください。"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            DispatchQueue.main.async {
                self.location = lastLocation
                self.locationError = nil  // エラーメッセージをクリア
                self.locations.append(lastLocation.coordinate)  // 位置情報を記録
            }
            print("Updated location: \(lastLocation.coordinate.latitude), \(lastLocation.coordinate.longitude)")
        } else {
            print("No location data available")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error.localizedDescription
        }
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied by the user")
                self.locationError = "位置情報へのアクセスが拒否されました。設定を確認してください。"
            case .locationUnknown:
                print("Location is currently unknown, but it may be available later")
                self.locationError = "現在の位置情報は取得できませんが、後ほど利用可能になるかもしれません。"
            default:
                print("Location Manager failed with error: \(error.localizedDescription)")
                self.locationError = "位置情報の取得に失敗しました。エラー: \(error.localizedDescription)"
            }
        } else {
            print("Failed to get location: \(error.localizedDescription)")
            self.locationError = "位置情報の取得に失敗しました。エラー: \(error.localizedDescription)"
        }
    }
}
