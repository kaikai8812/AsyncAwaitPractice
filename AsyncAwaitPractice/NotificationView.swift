//
//  NotificationView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/08.
//

import SwiftUI

struct NotificationView: View {
    
    let center = NotificationCenter.default
    
    @State private var text = "初回起動です！なので"
    @State private var count = 0
    
    var body: some View {
        Text("\(text)、\(count)回目")
            .task {
                let willEnter = center.notifications(named: UIApplication.willEnterForegroundNotification)
                for await notification in willEnter {
                    print("🌝:\(notification)")
                    text = "再起動"
                    count += 1
                }
            }
    }
    
}

#Preview {
    NotificationView()
}
