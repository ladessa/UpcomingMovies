//
//  SearchViewController.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 19/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import Foundation
import UIKit
import Gloss
import Alamofire
import JGProgressHUD

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //MARK: var declarations and IBOutlets
    @IBOutlet weak var  tbMovies : UITableView!
    private var listSearch: Array<Movie> = []
    var searchActive : Bool = false
    let progressHUD = JGProgressHUD(style: JGProgressHUDStyle.dark)
    let tbSpinnerFooter : UIActivityIndicatorView  = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var currentPage : Int = 1
    var totalPages : Int = 1
    var loadingMore : Bool = false
    var currentText : String = ""
    
    //MARK: IBActions
    @IBAction func btnBackClick(sender: AnyObject) {
        self.presentingViewController!.dismiss(animated: true, completion: { _ in })
        
    }
    
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewWidth : CGFloat = UIScreen.main.bounds.size.width
        
        //creating the loading to add in tableview's footer
        tbSpinnerFooter.frame = CGRect(x:0, y: 0, width:viewWidth, height: 44) //center the spinner in TableView - 44 is the default height
        tbSpinnerFooter.startAnimating()
        
        //the tableview's footer is initally nil
        self.tbMovies.tableFooterView = nil;
    }
    
    
    //MARK:  Tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listSearch.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieSearchCell = (tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell", for: indexPath as IndexPath) as! MovieSearchCell)
        
        let search = listSearch[indexPath.row]
        let thumbUrl = URL(string: ConstantHelper.kThumbURL)?.appendingPathComponent(search.poster_path!)

        cell.title.text = search.title
        cell.rating.text  = "\(search.vote_average!)"
    
        cell.thumb.sd_setImage(with: thumbUrl, placeholderImage: UIImage(named:"nextel_loading"))//SDWebImage library: A guarantee that the same URL won't be downloaded several times - cache management
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = self.listSearch.count - 1
        if !self.loadingMore && indexPath.row == lastRowIndex - 1 { //check if it's the last cell
            if(self.currentPage < self.totalPages) { // check if there's more movies to load
                self.loadingMore = true
                self.currentPage += 1
                getMoviesWithtext(text: currentText)
            }
            else {
                self.tbMovies.tableFooterView = nil; //there's no more movies to load
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieSelected = listSearch[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsView") as! DetailsViewController
        vc.movieSelected = movieSelected.movieDaoFromMovie()
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Search functions
    func clearSearch() {
        self.listSearch = []
        self.progressHUD?.dismiss()
        self.totalPages = 0
        self.currentText = ""
        self.tbMovies.reloadData()
        self.tbMovies.tableFooterView = nil;
    }
    
    
    //MARK: TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if searchText != "" {
            getMoviesWithtext(text: searchText)
        }
        else {
            clearSearch()
        }
        
        return true
    }
    
    
    //MARK: call services
    func getMoviesWithtext(text: String) {
        progressHUD?.textLabel.text = "Searching..."
        progressHUD?.show(in: view, animated: true)
        
        MovieManager.searchMoviesWithText(text: text, page: self.currentPage,  completion: { (listMovies : Array<Movie>?,totalPages, error) in
            if listMovies != nil {
                self.listSearch.append(contentsOf: listMovies!)
                self.progressHUD?.dismiss()
                self.totalPages = totalPages
                if(self.listSearch.count > 9 && self.currentPage < self.totalPages) {
                    self.tbMovies.tableFooterView = self.tbSpinnerFooter;
                }
                self.tbMovies.reloadData()
                self.loadingMore = false
                self.currentText = text
            } else {
                self.clearSearch()
            }
        })
    }
    
    
    
}
