//
//  LinesTestView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/02/28.
//

import SwiftUI

struct LinesTestView: View {
    
    @StateObject
    var viewModel: LinesTestViewModel
    
    init() {
        _viewModel = .init(wrappedValue: LinesTestViewModel())
    }
    
    var text: String = ""
    
    var body: some View {
        Text(viewModel.text)
        
        Button("読み込み") {
            Task.detached {
                await viewModel.readText
            }
        }
        
    }
    
}

#Preview {
    LinesTestView()
}
