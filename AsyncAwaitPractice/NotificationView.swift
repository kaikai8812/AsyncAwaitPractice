//
//  NotificationView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/08.
//

import SwiftUI

struct NotificationView: View {
    
    var viewModel: NotificationViewModel = .init()
    
    var body: some View {
        
        VStack(spacing: 10) {
            Button("監視開始") {
                Task {
                    await viewModel.appCheckStatus()
                }
            }
            
            Button("監視終了") {
                Task {
                    viewModel.cleanUp()
                }
            }
            
            Button("カウント！！") {
                Task {
                    let counter = Counter()
                    
                    for try await count in counter.countDown(amount: 10) {
                        print("あと\(count)!")
                    }
                }
            }
        }
    }
    
    class NotificationViewModel {
        var enterForegroundTask: Task<Void,Never>?
        
        func appCheckStatus() async {
            let notificationCenter = NotificationCenter.default
            print("監視開始！")
            enterForegroundTask = Task {
                let willEnterForeGround =
                await notificationCenter.notifications(named: UIApplication.willEnterForegroundNotification)
                
                for await notification in willEnterForeGround {
                    print("アプリ起動")
                }
            }
        }
        
        func cleanUp() {
            print("監視終了！")
            enterForegroundTask?.cancel()
        }
    }
    
}
