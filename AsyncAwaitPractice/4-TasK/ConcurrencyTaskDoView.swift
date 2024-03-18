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
                var s = await fetchValues(ids: ["1", "2", "3", "4"])
                print("取得できた結果: \(s)")
            }
        }
    }
    
    private func fetchValues(ids: [String]) async -> [String: String?] {
        
        // 非同期で、配列分の子タスクを作成する
        
        return await withTaskGroup(of: (String, String?).self) { group in
            for id in ids {
                group.addTask {
                    print("子タスク追加が完了したもの:\(id)")
                    return (id, await getvalue(id: id))
                }
            }
            
            var values: [String: String?] = [:]
            
            // 子タスクは、並列で実行される。
            for await (id, value) in group {
                print("データ取得：id: \(id), value: \(String(describing: value))")
                values[id] = value
            }
            
            print(values)
            return values
            
        }
        
    }
    
    private func getvalue(id: String) async -> String {
        await Util.wait(second: 1)
        return "\(id + "valueです！")"
    }
}

#Preview {
    動的に非同期なタスクを実行するView()
}
