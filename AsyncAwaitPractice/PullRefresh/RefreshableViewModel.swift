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
    case task
    case refreshable
}


@MainActor
final class RefreshableViewModel: ObservableObject {
    @Published private(set) var uiState : RefreshableUiState
    
    init() {
        self.uiState = RefreshableUiState()
        
        /// 問題点：現状、データの初期化を、viewModelのinit時に実行している。
        /// これでは、非同期処理が投げっぱなしになっており、
        /// 非同期処理のキャンセルなどができない。
        Task {
            await refreshRandomNumbers()
        }
    }
    
    func send(_ action: RefreshableAction) async {
        switch action {
        case .refreshable, .task:
            await refreshRandomNumbers()
        }
    }
}

private extension RefreshableViewModel {
    func refreshRandomNumbers() async {
        uiState.isLoading = true
        
        do {
            uiState.randamNumbers = try await getRandamNumbers()
        } catch is CancellationError {
            print("タスクがキャンセルされました。")
        } catch {
            print("キャンセラレーションエラー以外のエラー")
        }
        
        uiState.isLoading = false
    }
    
    nonisolated
    func getRandamNumbers() async throws -> [Int] {
        
        try await Task.sleep(for: .seconds(2))
        
        var randomNumbers: [Int] = []
        for _ in 0..<10 {
            randomNumbers.append(.random(in: 0..<10))
        }
        
//        if randomNumbers.contains(where: { num in
//            num == 4
//        }) {
//            throw CancellationError()
//        }
        
        return randomNumbers
    }
}
