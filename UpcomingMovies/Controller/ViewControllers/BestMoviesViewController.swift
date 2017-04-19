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
        
        MovieManager.getMoviesWithAverageGreaterThan(average: 5, page: currentPage, completion: { (listMovies : Array<Movie>?,totalPages, error) in
            if listMovies != nil {
                self.listMovies.append(contentsOf: listMovies!)
                self.totalPages = totalPages
                self.progressHUD?.dismiss()
                self.tbMovies.reloadData()
                self.loadingMore = false
            } else {
                self.progressHUD?.dismiss()
                Helper.displayAlert(title: "Error!", message: "Error trying to get movies. Please, try again later.", controller: self)
            }
        })
    }
    
    //MARK:  Tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMovies.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = (tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath as IndexPath) as! MovieCell)
        
        let movie = listMovies[indexPath.row]
        let thumbUrl = URL(string: ConstantHelper.kThumbURL)?.appendingPathComponent(movie.poster_path!)

        cell.title.text = movie.title
        cell.rating.text  = "\(movie.vote_average!)"
        cell.thumb.sd_setImage(with: thumbUrl, placeholderImage: UIImage(named:"trivago_loading"))//SDWebImage library: A guarantee that the same URL won't be downloaded several times - cache management
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = self.listMovies.count - 1
        if !self.loadingMore && indexPath.row == lastRowIndex - 1 { //check if it's the last cell
            if(self.currentPage < self.totalPages) { // check if there's more movies to load
                self.loadingMore = true
                self.currentPage += 1
                getMovies()
            }
            else {
                self.tbMovies.tableFooterView = nil; //there's no more movies to load
            }
            
        }
    }
}


