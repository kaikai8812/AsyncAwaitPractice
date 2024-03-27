//
//  SendableCompileErrorTest.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/28.
//

import Foundation

actor SendableActor {
    func returnString(string: NSMutableString) -> NSMutableString {
        return string
    }
    
    func returnSendableString(string: String) -> String {
        return string
    }
    
    /// actor内で、sendable準拠をしていない値を渡してもワーニングが出ることはない。
    /// actor内で使用されている時点で、データ競合の安全性は担保されているため。
    func test() {
        let result = returnString(string: .init(string: "aaa"))
    }
}

//NSMutableStringは、Sendableに準拠していないので、ワーニングが出る。
func someFunc(actor: SendableActor, string: NSMutableString) async {
    let result = await actor.returnString(string: string)
    print(result)
}

// Stringは、Sendableに準拠しているので、ワーニングがでない。
func some2Func(actor: SendableActor, string: String) async {
    let result = await actor.returnSendableString(string: string)
    print(result)
}
