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
            //            continuation.resume(returning: fetchUser())
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

class Score {
    var logs: [Int] = []
    private(set) var highScore: Int = 0
    
    func update(with score: Int) {
        logs.append(score)
        if score > highScore {
            highScore = score
        }
    }
}

class SerialScore {
    
    private let serialQueue = DispatchQueue(label: "serial-dispatch-queue")
    var logs: [Int] = []
    private(set) var highScore: Int = 0
    
    func update(with score: Int, completion : @escaping ((Int) -> ())) {
        serialQueue.async { [weak self] in
            guard let s = self else { return }
            self?.logs.append(score)
            if score > s.highScore {
                s.highScore = score
            }
            completion(s.highScore)
        }
    }
}

actor ActorScore {
    var logs: [Int] = []
    private(set) var newScore: Int = 0
    
    func update(with score: Int) async {
        newScore = await update(score)
        logs.append(score)
    }
    
    private func update(_ score: Int) async -> Int {
        try! await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000))
        return score
    }
}

actor Actor2Score {
    var localLogs: [Int] = []
    private(set) var highScore: Int = 0
    
    func update(with score: Int) async {
        // requestHighScoreを呼ぶ順番で結果が変わる
        localLogs.append(score)
        highScore = await requestHighScore(with: score)
    }
    
    // サーバーに点数を送るとサーバーが集計した自分の最高得点が得られると想定するメソッド
    // 実際は2秒まって引数のscoreを返すだけ
    func requestHighScore(with score: Int) async -> Int {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)  // 2秒待つ
        return score
        
    }
}
actor HashTest: Hashable {
    
    private(set) var num: Int = 0
    
    static func == (lhs: HashTest, rhs: HashTest) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    //  ここには、nonisolatedはつけることはできない。なぜなら、これがつけれてしまうと、データの競合をactorで防ぎきれなくなってしまうから。
    func inc() {
        num += 1
    }
    
    let id: UUID = .init()
    
    
}
