//
//  DetailsViewController.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 19/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class DetailsViewController: UIViewController {
    
    //MARK: var declarations and IBOutlets
    @IBOutlet weak var  lblTitle : UILabel!
    @IBOutlet weak var  imgMovie : UIImageView!
    @IBOutlet weak var  txtOverview : UITextView!
    
    var movieSelected : MovieDAO!
    
    
    //MARK: IBActions
    @IBAction func btnBackClick(sender: AnyObject) {
        self.presentingViewController!.dismiss(animated: true, completion: { _ in })
    }
    
    
    //Mark:  Override Methods
    override func viewDidLoad() {
        self.lblTitle.text = movieSelected.title
        self.txtOverview.text = movieSelected.overview
        
        let thumbUrl = URL(string: ConstantHelper.kThumbURL)?.appendingPathComponent(movieSelected.poster_path!)
        self.imgMovie.sd_setImage(with: thumbUrl, placeholderImage: UIImage(named:"nextel_loading"))//SDWebImage library: A guarantee that the same URL won't be downloaded several times - cache management

    }

}
