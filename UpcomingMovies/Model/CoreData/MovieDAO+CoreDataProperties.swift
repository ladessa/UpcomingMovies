//
//  MovieDAO+CoreDataProperties.swift
//  
//
//  Created by Igor Ladessa on 19/04/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MovieDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDAO> {
        return NSFetchRequest<MovieDAO>(entityName: "MovieDAO");
    }

    @NSManaged public var title: String?
    @NSManaged public var vote_average: NSDecimalNumber?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?

}
