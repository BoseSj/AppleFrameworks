// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

/// An extension to provide custom transformation logic for Combine publishers.
extension Publisher {
    /// Transforms each element into a new publisher that emits the element multiple times,
    /// where the count of repetitions is equal to the element's value itself.
    ///
    /// - Parameter maxPublishers: The maximum number of concurrent publishers to subscribe to.
    /// - Returns: A publisher that emits the repeated elements.
    func repeatElements(maxPublishers: Subscribers.Demand = .unlimited) -> AnyPublisher<Output, Failure> where Output: BinaryInteger {
        return self.flatMap(maxPublishers: maxPublishers) { item in
            // Create an array of the item, repeated 'item' times, and turn it into a publisher.
            Array(repeating: item, count: Int(item))
                .publisher
                .setFailureType(to: Failure.self)
        }
        .eraseToAnyPublisher()
    }
}

var cancellable: Set<AnyCancellable> = []

// Using the new custom operator
//[1, 2, 4, 5].publisher
//    .print("Input")
//    .repeatElements(maxPublishers: .max(1))
//    .sink { value in
//        print("got: \(value)")
//    }
//    .store(in: &cancellable)


/// Networking in Combine


func fetchProduct<T: Codable>(with id: String = "1") -> AnyPublisher<T, Error> {
	let url = URL(string: "https://fakestoreapi.com/products/\(id)")!
	return URLSession.shared.dataTaskPublisher(for: url)
		.handleEvents(receiveSubscription: { _ in
			print("receiveSubscription")
		}, receiveOutput: { _ in
			print("output")
		}, receiveCompletion: { _ in
			print("receiveCompletion")
		}, receiveCancel: {
			print("cancel")
		}, receiveRequest: { _ in
			print("request")
		})
		.tryMap { item in
			try JSONDecoder().decode(T.self, from: item.data)
		}
		.eraseToAnyPublisher()
}


// MARK: - Product
struct Product: Codable {
	let id: Int
	let title: String
	let price: Double
	let description, category: String
	let rating: Rating
}

// MARK: - Rating
struct Rating: Codable {
	let rate: Double
	let count: Int
}

let product: AnyPublisher<Product, Error> = fetchProduct()
	.share()
	.eraseToAnyPublisher()

product
	.receive(on: DispatchQueue.main)
	.sink(receiveCompletion: { result in
		switch result {
			case .finished:
				print("Finished")
			case .failure(let failure):
				print("Failed with \(failure.localizedDescription)")
		}
	}, receiveValue: { product in
		print("product")
		print(product)
	})
	.store(in: &cancellable)

product
	.receive(on: DispatchQueue.main)
	.sink(receiveCompletion: { result in
		switch result {
			case .finished:
				print("Finished")
			case .failure(let failure):
				print("Failed with \(failure.localizedDescription)")
		}
	}, receiveValue: { product in
		print("product")
		print(product)
	})
	.store(in: &cancellable)

RunLoop.main.run()
