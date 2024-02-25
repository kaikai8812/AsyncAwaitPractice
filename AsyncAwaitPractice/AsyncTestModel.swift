//
//  AsyncTestModel.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/02/25.
//

import Foundation

class UserData {
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    var name: String
    var age: Int
}

class AsyncTestModel {
    
    func  fetchUser() -> UserData {
        return .init(name: "TestName", age: 10)
    }
    
    func asyncFetchUser() async -> UserData {
        return await withCheckedContinuation { continuation in
            continuation.resume(returning: fetchUser())
        }
    }
    
    func fetchUserOrError(isError: Bool) -> Result<UserData, Error>{
        if isError {
            return .failure(TempError())
        } else {
            return .success(.init(name: "成功！", age: 100))
        }
    }
    
    //  ↓ async関数に変換することができる。
    
    func asyncfetchUserOrError(isError: Bool) async throws -> UserData {
        return try await withCheckedThrowingContinuation { conti in
            conti.resume(with: fetchUserOrError(isError: isError))
        }
    }
    
}
