//
//  ContentView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2023/11/11.
//

import SwiftUI

class TempError: Error {
    init() {
        print("エラー生成")
    }
}

class AsyncClass {
    init(stringParam: String) async {
        print("asyncのinitを持ったクラスがinitされたぞ")
    }
}

struct ContentView: View {
    var body: some View {
        Button {
            Task.detached {
                await simpleAsyncFunc(string: "テストです")
            }
        } label: {
            Text("どシンプルasync関数")
        }
        .padding()
        
        Button {
            Task.detached {
                let result = await asyncRerutnFunc()
                print(result)
            }
        } label: {
            Text("戻り値async関数")
        }
        .padding()
        
        Button {
            Task.detached {
                do {
                    try await asyncErrorFunc(isError: true)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } label: {
            Text("エラーが発生するasync関数")
        }
        .padding()
        
        Button {
            Task.detached {
                let asyncClass = await AsyncClass(stringParam: "テスト")
                
            }
        } label: {
            Text("asyncClassを作成する関数")
        }
        .padding()

    }
    
    // どシンプルなasync関数
    func simpleAsyncFunc(string: String) async {
        print(string)
    }
    
    //  帰り値のあるasync関数
    func asyncRerutnFunc() async -> String {
        return "戻り値だよん"
    }
    
    func asyncErrorFunc(isError: Bool) async throws {
        if isError {
            throw TempError()
        } else {
            print("エラー関数を、エラーなしで呼び出した。")
        }
    }
}

#Preview {
    ContentView()
}
