//
//  DetchedTestView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/27.
//

import SwiftUI

struct DetchedTestView: View {
    
    let actorModel = MainActoreDetachedViewModel()
    let nonActorModel = NonActorDetachedViewModel()
    
    var body: some View {
        Button("MainActor") {
            actorModel.hogeFunc()
        }
        .padding()
        
        Button("NonMainActor") {
            nonActorModel.fugaFunc()
        }.padding()
        
        Button("task") {
            Task {
                await nonActorModel.get()
            }
        }
    }
}

#Preview {
    DetchedTestView()
}


@MainActor
final class MainActoreDetachedViewModel {
    
    nonisolated
    init() {}

    func hogeFunc() {
        Task(priority: .high) {
            print("Task直下：実行スレッドisMain? → \(Thread.current.isMainThread)")
            
            Task {
                print("子Task：実行スレッドisMain? → \(Thread.current.isMainThread)")
            }
            
            Task.detached(priority: .high) {
                print("Detachedtask：実行スレッドisMain? → \(Thread.current.isMainThread)")
                
            }
        }
    }
    
}


final class NonActorDetachedViewModel {
    
    func fugaFunc() {
        Task(priority: .low) {
            print("Task直下：実行スレッドisMain? → \(Thread.current.isMainThread)")
            
            Task {
                print("子Task：実行スレッドisMain? → \(Thread.current.isMainThread)")
            }
            
            Task.detached(priority: .high) {
                print("Detachedtask：実行スレッドisMain? → \(Thread.current.isMainThread)")
                
            }
        }
    }
    
    func get() async {
        
        var task: Task<Void, Never>?
        
        await TimeTracker.track {
            task = Task.detached {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await Util.wait(second: 2)
                    }
                    
                    for await _ in group {
                        print("withTask 終了")
                    }
                }
                
                async let asyncFunc = await Util.wait(second:2)
                await asyncFunc
                print("async let 終了")
                
            }
            
            /// 親タスクをキャンセルすると、UnStructuredであってもキャンセルされる。
            /// 子タスク側で、キャンセル処理を適切に行っていることが条件
            /// 今回だと、Util.wait()メソッド側で、キャンセルチェック処理が走っているので、子タスクもキャンセルされる。
            task?.cancel()
        }
    }
    
}
