//
//  LinesTestViewModel.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/02/28.
//

import Foundation

@MainActor
class LinesTestViewModel: ObservableObject {
    
    @Published var text: String = ""
    
    
     func readText() {
        Task {
            guard let url = Bundle.main.url(
                forResource: "testText",
                withExtension: "txt"
            ) else { 
                return
            }
            
            do {
                for try await line in url.lines {
                    print(line)
                    self.text += "\(line)\n"
                }
            } catch {
                print(error.localizedDescription)
            }
            print("")
        }
    }
}
//
//#Preview {
//    LinesTestView()
//}
