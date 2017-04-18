//
//  MovieManager.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 18/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//


import Foundation
import Alamofire
import Gloss


class MovieManager: NSObject {

//https://api.themoviedb.org/3/discover/movie/?certification_country=US&certification=R&sort_by=vote_average.desc&api_key=e67a81b1117e0d8fc734bbcdd2579d01

    class func getMoviesWithAverageGreaterThan(average:Int, page:Int, completion : @escaping (Array<Movie>?, Int, NSError?) -> ()) {
        var listMovies: Array<Movie> = []
        
        Alamofire.request(ConstantHelper.kUrlDiscoverMovies, method: .get, parameters: ["api_key": ConstantHelper.kApiKey, "certification" : average, "sort_by" : "vote_average.desc" ]).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let repoJSON = response.result.value {
                        let jsonArray = repoJSON as? NSMutableArray
                        for item in jsonArray! {
                            guard let movie = Movie(json: item as! JSON) else
                            {
                                print("Issue deserializing model")
                                return
                            }
                            listMovies.append(movie)
                        }
                        if let paginationCount = response.response?.allHeaderFields["x-pagination-page-count"] as? String {
                            completion(listMovies, Int(paginationCount)!, nil)
                        }
                        else {
                            completion(listMovies, 0, nil)
                        }
                    }
                    break
                case .failure(let error):
                    completion(nil, 0, error as NSError?)
                    break
                }

        
        }
    }

}
