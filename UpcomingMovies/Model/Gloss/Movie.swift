//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 18/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import Foundation
import Gloss

struct Movie: Glossy {
    let title : String?
    let vote_average : Int?
    let overview : String?
    let poster_path : String?
    
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




