// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import Combine

var cancellable: Set<AnyCancellable> = []

let url = URL(string: "https://fakestoreapi.com/products/1")!


func fetchProducts<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .mapError({ $0 as Error })
        .tryMap({ response in
            let decoder = JSONDecoder()
            
            guard let urlResponse = response.response as? HTTPURLResponse,
                  (200...299).contains(urlResponse.statusCode) else {
                throw try decoder.decode(APIError.self, from: response.data)
            }
            
            return try decoder.decode(T.self, from: response.data)
        })
        .eraseToAnyPublisher()
}


/// API Error
struct APIError: Codable, Error {}

/// Product
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description, category: String
    let rating: Rating
}

/// Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}


let products: AnyPublisher<Product, Error> = fetchProducts(from: url)
    .share()
    .eraseToAnyPublisher()
    
products
    .receive(on: DispatchQueue.main)
    .sink { completion in
        switch completion {
            case .finished:
                print("Process Completed")
            case .failure(let error):
                print(error.localizedDescription)
        }
        
    } receiveValue: { product in
        print("product")
        print(product)
    }
    .store(in: &cancellable)


RunLoop.main.run(until: .distantFuture)

