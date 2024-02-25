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
        
        Button("ActorScore") {
            Task.detached {
                await actorScore.update(with:100)
                await print(actorScore.highScore)
            }
            
            Task.detached {
                await actorScore.update(with:120)
                await print(actorScore.highScore)
            }
        }
    }
}

#Preview {
    DataRaceView()
}
