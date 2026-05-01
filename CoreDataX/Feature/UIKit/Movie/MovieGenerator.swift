//
//  MovieGenerator.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//

import Foundation
import FoundationModels


@MainActor
final class MovieGenerator {
    
    static let `main` = MovieGenerator()
    
    private init?(){
        switch SystemLanguageModel.default.availability {
            case .available: print("All Good")
            default:
                print("Not Available")
                return nil
        }
    }
    
    func generateMovie() async throws -> String {
        let instructions = """
            You are a movie title generator.
            Return exactly one movie title.
            Output plain text only with no quotes, labels, emojis, or extra commentary.
            Keep the title under 6 words.
            """
        let session = LanguageModelSession(instructions: instructions)
        let simpleQry = "Generate one original movie title."
        
        return try await session.respond(to: simpleQry).content
    }
}
