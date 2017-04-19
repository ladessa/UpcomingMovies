//
//  Helper.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 19/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Helper: NSObject {
    
    class func displayAlert(title: String, message: String, controller: UIViewController) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(dismissAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func heighForText(text: String, font: UIFont, maxSize: CGSize) -> CGFloat {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size.height
    }
    
    class func saveMovie(movie : Movie ) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "MovieDAO",
                                                 in:managedContext)
        
        let movieDAO = NSManagedObject(entity: entity!,
                                         insertInto: managedContext) as! MovieDAO
        
        let voteInt = NSDecimalNumber.init(value: movie.vote_average!)
        movieDAO.title = movie.title
        movieDAO.vote_average =  voteInt
        movieDAO.overview = movie.overview
        movieDAO.poster_path = movie.poster_path
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    


    
    
}
