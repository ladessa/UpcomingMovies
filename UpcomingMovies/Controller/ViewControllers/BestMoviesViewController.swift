//
//  BestMoviesViewController.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 18/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import UIKit
import CoreData
import Gloss
import Alamofire
import JGProgressHUD

class BestMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    //MARK: var declarations and IBOutlets
    @IBOutlet weak var  tbMovies : UITableView!
    private var listMovies: Array<Movie> = []
    let progressHUD = JGProgressHUD(style: JGProgressHUDStyle.dark)
    let tbSpinnerFooter : UIActivityIndicatorView  = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var currentPage : Int = 1
    var totalPages : Int = 1
    var loadingMore : Bool = false
    
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewWidth : CGFloat = UIScreen.main.bounds.size.width
        
        tbSpinnerFooter.frame = CGRect(x:0, y:0, width: viewWidth, height: 44) //center the spinner in TableView - 44 is the default height
        tbSpinnerFooter.startAnimating()
        self.tbMovies.tableFooterView = tbSpinnerFooter;
        getMovies()
    }
    
    //MARK: call services
    func getMovies() {
        progressHUD?.textLabel.text = "Loading movies..."
        progressHUD?.show(in: view, animated: true)
        
        MovieManager.getPopularMovies(currentPage, completion: { (listMovies : Array<Movie>?,totalPages, error) in
            if listMovies != nil {
                self.listMovies.appendContentsOf(listMovies!)
                self.totalPages = totalPages
                self.progressHUD.dismiss()
                self.tbMovies.reloadData()
                self.loadingMore = false
            } else {
                self.progressHUD.dismiss()
                Helper.displayAlert("Error!", message: "Error trying to get movies. Please, try again later.", controller: self)
            }
        })
    }
}


