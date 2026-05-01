//
//  ImageTransformer.swift
//  CoreDataX
//
//  Created by SJ Basak on 01/05/26.
//

import UIKit
import CoreData


final class ImageTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return nil }
        
        let data = try? NSKeyedArchiver.archivedData(
            withRootObject: image,
            requiringSecureCoding: true
        )
        
        return data
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        return try? NSKeyedUnarchiver
            .unarchivedObject(ofClass: UIImage.self, from: data)
    }
}
