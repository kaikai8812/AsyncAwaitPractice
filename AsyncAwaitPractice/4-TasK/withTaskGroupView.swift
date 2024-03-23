//
//  withTaskGroupView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/17.
//

import SwiftUI

struct withTaskGroupView: View {
    
    @State var user: UserInfo?
    
    var body: some View {
        Text("name: \(user?.name ?? "")")
        Text("age: \(user?.age ?? 0)")
        
        Button("データ取得") {
            Task {
                user = await fetchUserData()
            }
        }
        
        Button("get-user") {
            Task {
                await TimeTracker.track {
                    await getUserName()
                }
            }
        }
        
        Button("get-age") {
            Task {
                await TimeTracker.track {
                    await getUserAge()
                }
            }
        }
        
        Button("全体") {
            Task {
                await TimeTracker.track {
                    await fetchUserData()
                }
            }
        }
        
    }
    
    private func getUserName() async -> String {
        await Util.wait(second: 3)
        return "太郎"
    }
    
    private func getUserAge() async -> Int {
        await Util.wait(second: 1)
        return 20
    }
    
    func fetchUserData() async -> UserInfo {
        var name: String?
        var age: Int?
        
        enum FetchType: Equatable {
            case name(String)
            case age(Int)
        }
        
        await withTaskGroup(of: FetchType.self) { group in
            
            group.addTask {
                print("nameLoading...")
                let name = await getUserName()
                print("nameDone!")
                return FetchType.name(name)
            }
            
            group.addTask {
                print("ageLoading...")
                let age = await getUserAge()
                print("ageDone!")
                return FetchType.age(age)
            }

            
            /// nextメソッドで、順次情報を取得する場合
            guard let first = await group.next() else {
                group.cancelAll()
                    return
            }
            
            switch first {
            case .name(let n):
                print("一回目:\(n)")
                name = n
            case .age(let a):
                print("一回目:\(a)")
                age = a
            }
            
            /// nextを使用することで
            /// 一つ目に取得できた値によって、後続の処理を変更することができる。
            /// 21歳だということがわかったら、nameはAPIで取得することをやめて、文字列を追加する。
            if first == .age(21) {
                name = "21歳の誰か"
                group.cancelAll()
                return
            }
            
            
            guard let second = await group.next() else {
                group.cancelAll()
                return
            }
            
            switch second {
            case .name(let n):
                print("2回目:\(n)")
                name = n
            case .age(let a):
                print("2回目:\(a)")
                age = a
            }
            
        }
        return UserInfo(name: name ?? "名前取得失敗", age: age ?? 100)
    }
}



#Preview {
    withTaskGroupView()
}



struct UserInfo {
    var name: String
    var age: Int
}
