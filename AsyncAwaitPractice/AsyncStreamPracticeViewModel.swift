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
    
    lazy var lazyLocations: AsyncStream<CLLocationCoordinate2D> = {
        AsyncStream { [weak self] con in
            self?.continuation = con
        }
    }()
    
    var locationWithError: AsyncThrowingStream<CLLocationCoordinate2D, Error> {
        AsyncThrowingStream { [weak self] conti in
            guard let self = self else { conti.finish(throwing: fatalError("selfがない")) }
            continuationWithError = conti
            
        }
    }
    
    private var continuationWithError: AsyncThrowingStream<CLLocationCoordinate2D, Error>.Continuation? {
        didSet {
            continuation?.onTermination = { @Sendable [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    
    var asyncStreamTask: Task<Void, Never>?

        //  continuationが操作されることで、いてレーションを回す際の値が送信される。
    private var continuation: AsyncStream<CLLocationCoordinate2D>.Continuation? {
        // continuation自体の値がセットされた時に、以下の処理がよばれる。
        didSet {
            continuation?.onTermination = { @Sendable [weak self] _ in
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
