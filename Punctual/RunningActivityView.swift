//
//  RunningActivityView.swift
//  Punctual
//
//  Created by 佐藤匠 on 2024/12/07.
//
import SwiftUI

struct RunningActivityView: View {
    let targetTime: Date
    let needSpeed: Double
    let speed: Double
    let remainingDistance: Double
    let totalDistance: Double
    
    private var speedDifference: Double {
        return speed - needSpeed
    }
    
    private var progressPercentage: Double {
        return (totalDistance - remainingDistance) / totalDistance
    }
    
    private var remainingTime: String {
        let now = Date()
            let difference = targetTime.timeIntervalSince(now) // 秒単位の差を取得
            
            if difference <= 0 {
                return "指定された時刻は過去です"
            }
            
            let minutes = Int(difference) / 60
            let seconds = Int(difference) % 60
            
            if minutes > 0 {
                return "\(minutes)分 \(seconds)秒"
            } else {
                return "\(seconds)秒"
            }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Top row with target time and need speed
            HStack {
                Text("Target Time")
                    .font(.system(size: 16, weight: .regular))
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Spacer()
                
                Text("Need Speed")
                    .font(.system(size: 16, weight: .regular))
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            HStack {
                Text(targetTime, style: .time)
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Text(String(format: "%.1f km/h", needSpeed))
                    .font(.system(size: 24, weight: .bold))
            }
            
            // Speed difference bar
            VStack(alignment: .center, spacing: 10) {
                Text(String(format: "%+.2f km/h", speedDifference))
                    .font(.system(size: 32, weight: .bold))
                
                ZStack(alignment: .leading) {
                    // Background bar
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    // Scale markers
                    HStack {
                        Text("-2")
                        Spacer()
                        Text("+2")
                    }
                    .font(.system(size: 14))
                    .offset(y: -20)
                    
                    // Indicator circles
                    HStack {
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width *
                                  (CGFloat(speedDifference + 2) / 4.0))
                        Circle()
                            .fill(Color.green)
                            .frame(width: 24, height: 24)
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 32, height: 32)
                            .offset(x: 20)
                    }
                }
            }
            .padding(.vertical, 20)
            
            // Bottom progress bar
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Text(remainingTime)
                    Spacer()
                    Text(String(format: "%.1f km/h", speed))
                    Spacer()
                    Text(String(format: "%.0fm", remainingDistance))
                }
                .font(.system(size: 16))
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background bar
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        // Progress bar
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width * CGFloat(progressPercentage),
                                   height: 8)
                        
                        // Progress indicator
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 16, height: 16)
                            .offset(x: geometry.size.width * CGFloat(progressPercentage) - 8)
                    }
                }
                .frame(height: 16)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding()
    }
}
