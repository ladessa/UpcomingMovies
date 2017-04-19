//
//  MovieCD+CoreDataProperties.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 19/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MovieCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCD> {
        return NSFetchRequest<MovieCD>(entityName: "MovieCD");
    }

    @NSManaged public var title: String?
    @NSManaged public var vote_average: Int16
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?

}
