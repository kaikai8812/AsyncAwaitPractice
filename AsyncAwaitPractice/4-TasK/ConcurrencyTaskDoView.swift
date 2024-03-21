//
//  ConcurrencyTaskDoView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/19.
//

import SwiftUI

struct 動的に非同期なタスクを実行するView: View {
    
    @State var list: [String: String?] = [:]
    
    var body: some View {
        Button("取得") {
            Task {
                do {
                    var data = try await fetchValues(ids: ["1", "2", "3", "4"])
                    print("取得できた結果: \(data)")
                } catch {
                    print("呼び出し元で、error発生を検知")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchValues(ids: [String]) async throws -> Void {
        
        try await TimeTracker.track {
            try await withThrowingTaskGroup(of: (String, String?).self) { group in
                
                for id in ids {
                    group.addTask {
//                        try Task.checkCancellation()
                        print("子タスク追加が完了したもの:\(id)")
                        return (id, await getvalue(id: id))
                    }
                }
                
//                group.addTask {
//                    return ("error", try await getValueWithError(isError: true))
//                }
                
                var values: [String: String?] = [:]
                
//                group.cancelAll()
                
                // 子タスクは、並列で実行される。
                for try await (id, value) in group {
                    print("データ取得：id: \(id), value: \(String(describing: value))")
                    values[id] = value
                }
                
                
                print(values)
            }
        }
    }
    
    private func getvalue(id: String) async -> String {
        await Util.wait(second: 3)
        return "\(id + "valueです！")"
    }
    
    private func getValueWithError(isError: Bool) async throws -> String {
        await Util.wait(second: 0)
        if isError { throw SampleError.TestError("テストエラーが発生しました。") }
        return "成功"
    }
}

enum SampleError: Error {
    case TestError(String)
}

#Preview {
    動的に非同期なタスクを実行するView()
}
