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
        
        Task {
            await refreshRandomNumbers()
        }
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
        
        try? await Task.sleep(for: .seconds(2))
        
        var randomNumbers: [Int] = []
        
        for _ in 0..<10 {
            randomNumbers.append(.random(in: 0..<10))
        }
        
        uiState.randamNumbers = randomNumbers
        uiState.isLoading = false
    }
}
