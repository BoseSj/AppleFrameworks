//
//  MovieProvider.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//


import UIKit
import CoreData
import Combine


final class MovieProvider: NSObject {
    
    let storage: CDXStoreProvider
    var resultController: NSFetchedResultsController<Movie>
    @Published var snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>?
    
    init(storage: CDXStoreProvider) {
        self.storage = storage
        
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptors: [NSSortDescriptor] = [
            NSSortDescriptor(keyPath: \Movie.name, ascending: true)
        ]
        request.sortDescriptors = sortDescriptors
        
        resultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: storage.context,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        self.resultController.delegate = self
        try! self.resultController.performFetch()
    }
}

extension MovieProvider {
    func add(with name: String) {
        storage.add(with: name)
    }
    func remove(movie: Movie) {
        storage.remove(movie: movie)
    }
}
extension MovieProvider: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
    ) {
        print("CONTENT FETCHED")
        let newSnapshot = snapshot
        
        self.snapshot = newSnapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    }
}
