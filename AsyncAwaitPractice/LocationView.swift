//
//  LocationView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/15.
//

import SwiftUI

struct LocationView: View {
    
    @StateObject
    private var locationManager: LocationManager
    
    init() {
        self._locationManager = StateObject(wrappedValue: LocationManager())
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
    }
}

#Preview {
    LocationView()
}
