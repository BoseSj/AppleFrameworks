//
//  Movie+FetchRequest.swift
//  CoreDataX
//
//  Created by SJ Basak on 06/05/26.
//

import Foundation
import CoreData


extension Movie: Identifiable {
    static var requestMoviesByPopularity: NSFetchRequest<Movie> = {
        var request = Movie.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Movie.rating, ascending: true)
        ]
        
        return request
    }()
}
