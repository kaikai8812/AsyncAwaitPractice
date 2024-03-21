//
//  TimeTracker.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/22.
//

import Foundation

struct TimeTracker {
    static func track(_ process: (() async -> Void )) async {
        let start = Date()
        await process()
        let end = Date()
        let span = end.timeIntervalSince(start)
        let doubleDigitSpan = String(format: "%.2f", span)
        print("\(doubleDigitSpan)秒経過")
    }
}
