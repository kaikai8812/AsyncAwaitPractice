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
                    
                    //                    for try await count in counter.countDown(amount: 10) {
                    //                        print("あと\(count)!")
                    //                    }
                    
                    let first = await try counter.countDown(amount: 10).first {
                        $0 % 2 == 0
                    }
                    
                    print("first: \(first)")
                    
                    
                    // 2の倍数だけを取得することができるAsyncSequenceを作成する。
                    let array = await try counter.countDown(amount: 10)
                        .filter { count in return count % 2 == 0 }
                        .map { count in return "\(count) + map変換済み" }
                    
                    // 2の倍数だけを取得したarrayを、for await ループで回すことができる。
                    // メソッドチェーンみたいを利用して、関数型みたいにも書くことができる。
                    for try await element in array {
                        print("🌝：\(element)")
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
