//
//  Movie+CoreDataProperties.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//
//

public import Foundation
public import CoreData
public import UIKit


public typealias MovieCoreDataPropertiesSet = NSSet

extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var director: String?
    @NSManaged public var name: String?
    @NSManaged public var poster: UIImage?
    @NSManaged public var rating: Int64

}

extension Movie : Identifiable {
	static var requestMoviesByPopularity: NSFetchRequest<Movie> = {
		var request = Movie.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \Movie.rating, ascending: true)
		]
		
		return request
	}()
}
