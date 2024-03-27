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
    
}
