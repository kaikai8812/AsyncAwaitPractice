//
//  RefreshableListView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/04/04.
//

import SwiftUI

struct RefreshableListView: View {
    
    let randamNumbers: [Int]
    let isLoading: Bool
    
    var body: some View {
        List(randamNumbers, id: \.self) { randamNumber in
            Text("\(randamNumber)")
        }
        .overlay {
            if isLoading {
                Text("ローディング中")
            }
        }
    }
}

#Preview {
    RefreshableListView(randamNumbers: [1,2,3,4,5], isLoading: true)
}
