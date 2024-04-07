//
//  RefreshableView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/04/04.
//

import SwiftUI

struct RefreshableView: View {
    
    @StateObject private var viewModel: RefreshableViewModel
    
    var body: some View {
        RefreshableListView(
            randamNumbers: viewModel.uiState.randamNumbers,
            isLoading: viewModel.uiState.isLoading
        )
        .refreshable {
            await viewModel.send(.refreshable)
        }
    }
    
    @MainActor
    init() {
        self._viewModel = StateObject(wrappedValue: RefreshableViewModel())
    }
    
}

#Preview {
    RefreshableView()
}
