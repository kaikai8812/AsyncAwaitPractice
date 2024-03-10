//
//  OridinalAsyncSequence.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/10.
//

import Foundation

public struct Counter {
    
    struct AsyncCounter: AsyncSequence {
        
        typealias Element = Int
        var amount: Int
        
        func makeAsyncIterator() -> AsyncIterator {
            return AsyncIterator(amount: amount)
        }
        
        struct AsyncIterator: AsyncIteratorProtocol {
            
            typealias Element = Int
            
            var amount: Int
            
            // 次の要素を返却するメソッド
            mutating func next() async throws -> Int? {
                guard amount >= 0 else {
                    return nil
                }
                
                let result = amount
                amount -= 1
                return result
            }
        }
    }
    
    func countDown(amount: Int) -> AsyncCounter {
        return AsyncCounter(amount: amount)
    }
    
}
