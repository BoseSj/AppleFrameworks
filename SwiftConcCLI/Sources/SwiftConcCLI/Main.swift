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

@concurrent
func someFunc() async {
    print("something happened")
}
func fun() {
    print(Thread.current)
    DispatchQueue.main.async {
        print("main queue")
        print(Thread.current)
    }
    // DispatchQueue.main.sync {
    //   print(Thread.current)
    // }
    DispatchQueue.global().async {
        print("global queue")
        print(Thread.current)
    }
    DispatchQueue.global().sync {
        print("global sync queue")
        print(Thread.current)
    }
}

class Loader: @unchecked Sendable {
    private(set) var result = [Data]()
    private let semaphore = DispatchSemaphore(value: 1)
    private let lock = NSLock()

    func setValue(data: Data) {
        lock.lock()
        self.result.append(data)
        lock.unlock()
    }
}

class Fetcher {
    func load(onSuccess: @Sendable @escaping (Data) -> ()) {
        let urls = [
            "https://practicalcoredata.com",
            "https://practicalcombine.com",
            "https://practicalswiftconcurrency.com"
        ].compactMap(URL.init)
        
        let group = DispatchGroup()

        for url in urls {
            group.enter()
            DispatchQueue.global().async {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data {
                        print("Finished \(url)")
                        DispatchQueue.main.async {
                            onSuccess(data)
                        }
                    }
                    group.leave()
                }.resume()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            print("All Done")
        }
    }
}
