//
//  RefreshableViewModel.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/04/04.
//

import Foundation
import Combine


struct RefreshableUiState {
    var randamNumbers: [Int] = []
    var isLoading = false
}

enum RefreshableAction {
    case refreshable
}


@MainActor
final class RefreshableViewModel: ObservableObject {
    @Published private(set) var uiState : RefreshableUiState
    
    init() {
        self.uiState = RefreshableUiState()
        
        //        Task {
        //            await refreshRandomNumbers()
        //        }
    }
    
    func send(_ action: RefreshableAction) async {
        switch action {
        case .refreshable:
            await refreshRandomNumbers()
        }
    }
}

private extension RefreshableViewModel {
    func refreshRandomNumbers() async {
        uiState.isLoading = true
        
        print("直下の場合：　メインスレッドか否か → \(Thread.isMainThread)")
        
        uiState.randamNumbers = await getRandamNumbers()
        uiState.isLoading = false
    }
    
    /// 重い同期処理を発生させる部分を、nonisolatedメソッドでmainActorでない別actorに
    /// 逃がしてあげることで、メインスレッドがブロックされることがなくなり、
    /// カクツキを抑えることができる。
    nonisolated
    func getRandamNumbers() async -> [Int] {
        do {
            for i in 0..<100_000 {
                print(i)
            }
            print("退避させた場合：　メインスレッドか否か → \(Thread.isMainThread)")
        }
        
        var randomNumbers: [Int] = []
        
        for _ in 0..<10 {
            randomNumbers.append(.random(in: 0..<10))
        }
        
        return randomNumbers
    }
}
