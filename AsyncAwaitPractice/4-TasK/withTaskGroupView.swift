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
    }
    
    private func getUserName() async -> String {
        await Util.wait(second: 3)
        return "太郎"
    }
    
    private func getUserAge() async -> Int {
        await Util.wait(second: 1)
        return 21
    }
    
    func fetchUserData() async -> UserInfo {
        var name: String?
        var age: Int?
        
        enum FetchType {
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
            
            for await fetchResult in group {
                switch fetchResult {
                case .name(let n):
                    name = n
                case .age(let a):
                    age = a
                }
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
