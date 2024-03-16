//
//  AsyncStreamPractice.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/14.
//

import Foundation
import CoreLocation

@MainActor
final class OridinalLocationManager: NSObject, ObservableObject {
    
    @Published
    var coordinate: CLLocationCoordinate2D = .init()
    
    //  外からよばれるシーケンス
    var locations: AsyncStream<CLLocationCoordinate2D> {
        AsyncStream { [weak self] con in
            self?.continuation = con
        }
    }
    
    private let locationManager = CLLocationManager()
    
    var asyncStreamTask: Task<Void, Never>?
    
//    private var test: AsyncStream<String>.Continuation
    
    //  continuationが操作されることで、いてレーションを回す際の値が送信される。
    private var continuation: AsyncStream<CLLocationCoordinate2D>.Continuation? {
        // continuation自体の値がセットされた時に、以下の処理がよばれる。
        didSet {
            continuation?.onTermination = { @Sendable [weak self] _ in
//                 非同期は、アプリ終了などで強制終了させられる可能性が十分ある。
                // 非同期が終了した場合は、ここが自動でよばれる。
                // 
                self?.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func setup() {
            locationManager.delegate = self

            switch locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    break
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    print("ダメでしたorz")
                @unknown default:
                    break
            }
        }
    
    func request() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startLocation() {
            locationManager.startUpdatingLocation()
        }
    
    func stopLocation() {
            locationManager.stopUpdatingHeading()
        continuation?.finish()
        }
    
    func stoptask() {
        asyncStreamTask?.cancel()
    }
}

extension OridinalLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        
        coordinate = lastLocation.coordinate
        
        // yieldで、値をcontinuationに対して送っている。
        continuation?.yield(lastLocation.coordinate)
    }
}
