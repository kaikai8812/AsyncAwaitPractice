//
//  Util.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/17.
//

import Foundation

struct Util {
    static func wait(second: UInt64) async {
        try? await Task.sleep(nanoseconds: second * NSEC_PER_SEC)
    }
}
