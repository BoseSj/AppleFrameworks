//
//  File.swift
//  CoreDataX
//
//  Created by SJ Basak on 06/04/26.
//

import Foundation
import Combine
import CoreData


final class CDXStoreProvider: ObservableObject {
    
    static let `main` = CDXStoreProvider()
    
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
		ValueTransformer.setValueTransformer(
			ImageTransformer(),
			forName: NSValueTransformerName("ImageTransformer")
		)
        self.container = NSPersistentContainer(name: "CDX")
        
        self.container
            .loadPersistentStores { description, error in
                if let error {
                    fatalError(error.localizedDescription)
                } else {
                    print(description)
                }
            }
    }
}

extension CDXStoreProvider {
    func add(with name: String) {
        let movie = Movie(context: self.context)
        movie.name = name
		let rating: [Int64] = [
			1, 2, 3, 4, 5
		]
		movie.rating = rating.randomElement() ?? 1
//        movie.poster = UIImage(systemName: "popcorn")
        
        try? self.context.save()
    }
    func remove(movie: Movie) {
        self.context.delete(movie)
        try? self.context.save()
    }
}

import UIKit
