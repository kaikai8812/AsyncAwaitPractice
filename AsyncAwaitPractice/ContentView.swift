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
    
    let model = AsyncTestModel()
    
    var body: some View {
        Button {
            Task.detached {
                let nonAsync = model.fetchUser()
                print(nonAsync)
                
                let asyncData = await model.asyncFetchUser()
                print(asyncData)
                
                let data = try await model.asyncfetchUserOrError(isError: true)
                print(data.name)
                
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
        
        Button {
            Task.detached {
                //  こうもかけるけど、、、
                let returnValue = await asyncRerutnFunc()
                await simpleAsyncFunc(string: returnValue)
                
                // こうやって、一気にawaitをつけることもできる(まとまった処理に、一括でawaitをつけることができるイメージ)
                await simpleAsyncFunc(string: asyncRerutnFunc())
            }
        } label: {
            Text("複数のasync関数を、一気に呼ぶ")
        }
        .padding()
        
        Button {
            Task.detached {
                await asyncTwoSeconeds()
            }
            
            Task.detached {
                await asyncTwoSeconeds2()
            }
            
        } label: {
            Text("並列実行")
        }
        .padding()
        
        Button {
            Task.detached {
                await asyncTwoSeconeds()
                await asyncTwoSeconeds2()
            }
        } label: {
            Text("直列実行")
        }
        .padding()
        
        Button {
            Task.detached {
                
                //  一度、変数にasync関数を閉じ込めて仕舞えば、同じタスク内でも、並列で処理を実行することができる。
                //  async let バインディングという。
                async let first: Void = asyncTwoSeconeds()
                async let second: Void = asyncTwoSeconeds2()
                
                await first
                await second
            }
        } label: {
            Text("並列実行パート2")
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
    
    func asyncTwoSeconeds() async {
        try! await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        print("１秒経過")
        try! await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        print("２秒経過、\(#function)が完了しました。")
    }
    
    func asyncTwoSeconeds2() async {
        try! await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        print("1秒経過!")
        try! await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        print("2秒経過、\(#function)が完了しました。")
    }
}

#Preview {
    ContentView()
}
