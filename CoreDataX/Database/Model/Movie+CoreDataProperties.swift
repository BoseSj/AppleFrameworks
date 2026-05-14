//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by SJ Basak on 06/05/26.
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
    @NSManaged public var actors: NSSet?
    @NSManaged public var characters: NSSet?

}

extension Movie {
	// MARK: Generated accessors for actors
    @objc(addActorsObject:)
    @NSManaged public func addToActors(_ value: Actor)

    @objc(removeActorsObject:)
    @NSManaged public func removeFromActors(_ value: Actor)

    @objc(addActors:)
    @NSManaged public func addToActors(_ values: NSSet)

    @objc(removeActors:)
    @NSManaged public func removeFromActors(_ values: NSSet)

}
