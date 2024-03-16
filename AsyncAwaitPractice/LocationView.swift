//
//  LocationView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/15.
//

import SwiftUI

struct LocationView: View {
    
    @StateObject
    private var locationManager: OridinalLocationManager
    
    init() {
        self._locationManager = StateObject(wrappedValue: OridinalLocationManager())
    }
    
    var body: some View {
        VStack {
            Text("緯度：\(locationManager.coordinate.latitude)")
            Text("経度：\(locationManager.coordinate.longitude)")
        }
        
        Button("位置情報読み取り開始") {
            locationManager.startLocation()
        }
        .onAppear {
            locationManager.setup()
        }
        
        Button("許可とり") {
            locationManager.request()
        }
        
        Button("監視開始(Task保持ver)") {
            //  taskを、インスタンスで保持するように修正。
            locationManager.asyncStreamTask =   Task {
                for await coordinate in locationManager.locations {
                    print("🌝\(coordinate)")
                }
            }
        }
        
        Button("監視開始(Lazyver)") {
            Task {
                for await coo in locationManager.lazyLocations {
                    print("☀️\(coo)")
                }
            }
        }
        
        Button("監視開始(Lazyve2)") {
            Task {
                for await coo in locationManager.lazyLocations {
                    print("🔥\(coo)")
                }
            }
        }
        
        Button("errorがあり得るstreamを監視") {
            Task {
                for try await con in locationManager.locationWithError {
                    print("👿\(con)")
                }
            }
        }
        
        Button("continuation終了") {
            locationManager.stopLocation()
        }
        
        Button("task終了") {
            locationManager.stoptask()
        }
    }
}

#Preview {
    LocationView()
}
