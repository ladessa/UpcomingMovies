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
    private var localMovies = [NSManagedObject]();

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
        
        if UserDefaults.standard.bool(forKey: "downloaded") {
            self.fetchLocalMovies()
        }
        else {
            getMovies()
            }
    }
    
    //MARK: call services
    func getMovies() {
        progressHUD?.textLabel.text = "Downloading movies..."
        progressHUD?.show(in: view, animated: true)
        
        MovieManager.getMoviesWithAverageGreaterThan(average: 5, page: currentPage, completion: { (totalPages, error) in
            if error == nil{
                self.totalPages = totalPages
                self.fetchLocalMovies()
                self.loadingMore = false
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "downloaded")
                userDefaults.synchronize()
            } else {
                self.progressHUD?.dismiss()
                Helper.displayAlert(title: "Error!", message: "Error trying to get movies. Please, try again later.", controller: self)
            }
        })
    }
    
    //MARK: CoreData
    
    func fetchLocalMovies() {
        progressHUD?.textLabel.text = "Loading movies..."
        progressHUD?.show(in: view, animated: true)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDAO")

        do {
            let results = try managedContext.fetch(fetchRequest)
            localMovies = results as! [NSManagedObject]
            self.progressHUD?.dismiss()
            self.tbMovies.reloadData()
        } catch let error as NSError {
            print("Could not list movies \(error), \(error.userInfo)")
        }
        catch {
            // Catch any other errors
        }
    }

    
    //MARK:  Tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localMovies.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = (tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath as IndexPath) as! MovieCell)
        
        let movie = localMovies[indexPath.row] as! MovieDAO
        let thumbUrl = URL(string: ConstantHelper.kThumbURL)?.appendingPathComponent(movie.poster_path!)

        cell.title.text = movie.title
        cell.rating.text  = "\(movie.vote_average!)"
        cell.thumb.sd_setImage(with: thumbUrl, placeholderImage: UIImage(named:"nextel_loading"))//SDWebImage library: A guarantee that the same URL won't be downloaded several times - cache management
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let movieSelected = localMovies[indexPath.row] as! MovieDAO
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsView") as! DetailsViewController
            vc.movieSelected = movieSelected
            self.present(vc, animated: true, completion: nil)
    }
}


