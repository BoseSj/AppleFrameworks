// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


@main
struct SwiftConcCLI {
    static func main() {
        Task {
            if let store = try? await fetchStoreAsync() {
                print(store)
            }
        }
        
        RunLoop.current.run()
    }
}
