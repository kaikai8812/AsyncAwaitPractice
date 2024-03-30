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

struct SendableTest: Sendable {
    var stringValue: String
    var nsStringValue: NSMutableString
}

struct GenericSendableTest<T> {
    var value: T
    
    func sample() -> T {
        return value
    }
}

///Genericを使用しているものをSendableに準拠させるためには、
///メンバーがSendableに準拠していることを表さなければならない。
extension GenericSendableTest: Sendable where T: Sendable {}

final class SendableClass: Sendable {
    let value = "aaa"
    
    ///  mutableなプロパティに対しては、警告が出る。
    var mutableValue: String
    
    init(mutableValue: String) {
        self.mutableValue = mutableValue
    }
    
    // これも、実質mutableなプロパティだと思うのだが、警告がでない🤔
    var computedValue: String {
        mutableValue + "ちゃむ"
    }
    
    func hoge(value: String) {
        mutableValue = value
        print(mutableValue)
    }
}
