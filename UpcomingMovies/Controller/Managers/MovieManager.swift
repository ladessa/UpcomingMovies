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

    class func getMoviesWithAverageGreaterThan(average:Int, page:Int, completion : @escaping (Array<Movie>?, Int, NSError?) -> ()) {
        var listMovies: Array<Movie> = []
        
        Alamofire.request(ConstantHelper.kUrlDiscoverMovies, method: .get, parameters: ["api_key": ConstantHelper.kApiKey, "certification" : average, "sort_by" : "vote_average.desc" ]).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let repoJSON = response.result.value as? JSON {
                        guard let jsonArray = repoJSON["results"] as? [Any]  else {
                            return
                        }
                        for item in jsonArray {
                            guard let movie = Movie(json: item as! JSON) else
                            {
                                print("Issue deserializing model")
                                return
                            }
                            listMovies.append(movie)
                        }
                        if let paginationCount = repoJSON["total_pages"] as? String {
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
