//
//  SwiftUIView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/02/27.
//

import SwiftUI

struct MainActorView: View {
    
    @StateObject
    private var viewModel: MainActorViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MainActorViewModel())
    }
    
    var body: some View {
        List {
            Text(viewModel.text)
            Button {
                viewModel.didTapButton()
            } label: {
                Text("テキストを更新。")
            }
        }
    }
}


@MainActor
final class MainActorViewModel: ObservableObject {
    @Published private(set) var text: String = ""
    
    // @MainActorで括られたtextを、nonisolatedメソッドで更新することができない。
//    nonisolated
    func updateText() {
        self.text = "更新"
    }
    
    //  以下の記述方法を取ることで、データ更新は、actor内で実施することができる → データ競合を防ぐことができる。
    nonisolated
    func fetchText() async -> String {
        return "更新"
    }

    func didTapButton() {
        Task {
            text = await fetchText()
        }
    }
}

#Preview {
    MainActorView()
}
