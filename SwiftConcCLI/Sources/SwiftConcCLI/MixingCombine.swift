//
//  StoreDetails.swift
//  SwiftConcCLI
//
//  Created by SJ Basak on 26/08/26.
//

import Foundation
import Combine


/// Mixing with Combine
func fetchStoreAsync() async throws -> StoreDetails? {
    var cancellable = Set<AnyCancellable>()
    let stores = fetchStore(&cancellable).values
    
    for try await store in stores {
        return store
    }
    
    return nil
}
func fetchStore(_ cancellable: inout Set<AnyCancellable>) -> AnyPublisher<StoreDetails, (any Error)> {
    let url = URL(string: "https://fakestoreapi.com/products/1")!
    
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: StoreDetails.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}


// MARK: - StoreDetails
struct StoreDetails: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let rating: Rating

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case description = "description"
        case category = "category"
        case rating = "rating"
    }
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int

    enum CodingKeys: String, CodingKey {
        case rate = "rate"
        case count = "count"
    }
}
