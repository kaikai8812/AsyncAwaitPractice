//
//  DataRaceView.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/02/25.
//

import SwiftUI

struct DataRaceView: View {
    var body: some View {
        
        let score = Score()
        
        Button("score") {
            DispatchQueue.global(qos: .default).async {
                score.update(with: 100)
                print(score.highScore)
            }

            DispatchQueue.global(qos: .default).async {
                score.update(with: 110)
                print(score.highScore)
            }
        }
        
        let sirialScore = SerialScore()
        
        Button("SerialScore") {
            DispatchQueue.global(qos: .default).async {
                sirialScore.update(with: 100) { highScore in
                    print(highScore)
                }
            }

            DispatchQueue.global(qos: .default).async {
                sirialScore.update(with: 110) { highScore in
                    print(highScore)
                }
            }
        }
        
        let actorScore = ActorScore()
        let actor2Store = Actor2Score()
        
        Button("testtest") {
            Task.detached {
                await actor2Store.update(with: 100)
                print(await actor2Store.localLogs)
                print(await actor2Store.highScore)
            }

            Task.detached {
                await actor2Store.update(with: 110)
                print(await actor2Store.localLogs)
                print(await actor2Store.highScore)
            }
        }
        
        Button("ActorScore") {
            Task.detached {
                await actorScore.update(with:100)
                print("①")
                print(await actorScore.logs)
                print("②")
                print(await actorScore.newScore)
                print("③")
            }
            
            Task.detached {
                await actorScore.update(with:200)
                print("④")
                print(await actorScore.logs)
                print("⑤")
                print(await actorScore.newScore)
                print("⑥")
            }
        }
    }
}

#Preview {
    DataRaceView()
}
