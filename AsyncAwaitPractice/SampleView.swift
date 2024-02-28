//
//  SampleView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/02/29.
//

import SwiftUI

struct SampleView: View {
    
    @State var aClass = SampleClass()
    @State var bClass: SampleClass?
    
    @State var aStruct = SampleStruct()
    @State var bStruct: SampleStruct?
    
    
    var body: some View {
        Text(String(aClass.value))
        
        Button("class") {
            //  a,b、どちらもクラス
//            a.value = 100
            bClass = aClass
            bClass?.update()
            print(bClass?.value)
            print(aClass.value)
        }
        
        Button("struct") {
            bStruct = aStruct
            bStruct?.update()
            print(bStruct?.value)
            print(aStruct.value)
        }
        
    }
    
    mutating func update() {
        bClass?.value = 1000
    }
}

#Preview {
    SampleView()
}

class SampleClass {
    var value: Int = 10
    
    func update() {
        value = 100
    }
}

struct SampleStruct {
    var value: Int = 10
    
    mutating func update() {
        value = 100
    }
}
