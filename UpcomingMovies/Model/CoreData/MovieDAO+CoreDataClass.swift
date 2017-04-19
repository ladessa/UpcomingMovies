//
//  MovieDAO+CoreDataClass.swift
//  
//
//  Created by Igor Ladessa on 19/04/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(MovieDAO)
public class MovieDAO: NSManagedObject {
    
    init?(movie: Movie) {
        self.title = movie.title
        self.overview = movie.overview
        self.poster_path = movie.poster_path
        
        self.vote_average = movie.vote_average as Int?
    }

}


