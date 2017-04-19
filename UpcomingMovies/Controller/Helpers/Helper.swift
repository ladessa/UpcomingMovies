//
//  Helper.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 19/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    class func displayAlert(title: String, message: String, controller: UIViewController) {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(dismissAction)
        controller.present(alertController, animated: true, completion: nil)
}



}
