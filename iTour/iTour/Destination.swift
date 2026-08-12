//
//  Destination.swift
//  iTour
//
//  Created by Cepheus on 10/08/26.
//

import Foundation
import SwiftData

@Model
class Destination {
	var name: String
	var desc: String
	var date: Date
	var priority: Int
    
	@Relationship(deleteRule: .cascade, inverse: \Sight.destination)
    var sights: [Sight] = []
	
	init(
		name: String = "",
		desc: String = "",
		date: Date = .now,
		priority: Int = 2
	) {
		self.name = name
		self.desc = desc
		self.date = date
		self.priority = priority
	}
}


