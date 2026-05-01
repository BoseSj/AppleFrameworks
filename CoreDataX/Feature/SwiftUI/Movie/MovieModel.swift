//
//  MovieModel.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//


import SwiftUI
import Combine
import CoreData

@MainActor
final class MovieModel: NSObject, ObservableObject {
    
    @Published var movies: [Movie] = []
    
    var storage: CDXStoreProvider
    private var controller: NSFetchedResultsController<Movie>!
    
    override init() {
        self.storage = .main
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptors: [NSSortDescriptor] = [
            NSSortDescriptor(keyPath: \Movie.name, ascending: true)
        ]
        request.sortDescriptors = sortDescriptors
        
        self.controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: storage.context,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        self.controller.delegate = self
        try! self.controller.performFetch()
        self.movies = self.controller.fetchedObjects ?? []
        let movieSections = self.controller
            .sections?
            .reduce(into: [String: [Movie]]()) { partialResult, section in
                partialResult[section.name] = section.objects as? [Movie] ?? []
            }
    }
    
}


extension MovieModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.movies = controller.fetchedObjects as? [Movie] ?? []
    }
}
