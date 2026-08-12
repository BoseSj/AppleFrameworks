//
//  Sight.swift
//  iTour
//
//  Created by SJ Basak on 10/08/26.
//

import Foundation
import SwiftData

@Model
class Sight {
    var name: String
	var destination: Destination?
    
    init(name: String, destination: Destination? = nil) {
        self.name = name
		self.destination = destination
    }
}
