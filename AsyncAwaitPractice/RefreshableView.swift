//
//  RefreshableView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/04/04.
//

import SwiftUI

struct RefreshableView: View {
    
    @State var count: Int = 0
    
    var body: some View {
        ScrollView {
            Text("リロード回数：\(count)")
                .padding()
        }
        .refreshable {
            try? await Task.sleep(for: .seconds(2))
            count += 1
        }
    }
}

#Preview {
    RefreshableView()
}
