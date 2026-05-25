// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import Combine

var cancellable: Set<AnyCancellable> = []
[1, 2, 4, 5].publisher
	.print()
	.flatMap(maxPublishers: .max(1), { item in
		Array(repeating: item, count: item)
			.publisher
	})
	.sink { value in
		print("got: \(value)")
	}
	.store(in: &cancellable)
