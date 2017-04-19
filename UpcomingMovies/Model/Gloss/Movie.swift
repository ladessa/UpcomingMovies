//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 18/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import Foundation
import Gloss
import CoreData

struct Movie: Glossy {
    let title : String?
    let vote_average : Int?
    let overview : String?
    let poster_path : String?
    
    func movieDaoFromMovie() -> MovieDAO{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "MovieDAO",
                                                 in:managedContext)
        
        let movieDAO = NSManagedObject(entity: entity!,
                                       insertInto: managedContext) as! MovieDAO

        let voteInt = NSDecimalNumber.init(value: self.vote_average!)
        movieDAO.title = self.title
        movieDAO.overview =  self.overview 
        movieDAO.poster_path = self.poster_path
        movieDAO.vote_average = voteInt

        return movieDAO
    }
    
    // MARK: - Deserialization
    init?(json: JSON) {
        guard let title: String = "title" <~~ json, //verifica se todos os campos vieram preenchidos
            let vote_average: Int = "vote_average" <~~ json,
            let overview: String = "overview" <~~ json,
            let poster_path: String = "poster_path" <~~ json
            else { //caso não venha poster_path, seta para vazio = unico campo destes que pode vir NULO (diferente de vazio)
                self.title = "title" <~~ json
                self.vote_average = "vote_average" <~~ json
                self.overview = "overview"
                self.poster_path = ""
                return
        }
        self.title = title
        self.vote_average = vote_average
        self.overview = overview
        self.poster_path = poster_path
    }
    
    // MARK: - Serialization
    func toJSON() -> JSON? {
        return jsonify([
            "title" ~~> self.title,
            "vote_average" ~~> self.vote_average,
            "overview" ~~> self.overview,
            "poster_path" ~~> self.poster_path
            ])
    }
    
    
   

}




