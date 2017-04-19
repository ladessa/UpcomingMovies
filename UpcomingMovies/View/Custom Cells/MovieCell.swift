//
//  MovieCell.swift
//  UpcomingMovies
//
//  Created by Igor Ladessa on 18/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//
import Foundation
import UIKit


class MovieCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var thumb: UIImageView!

    
    
    
    override func awakeFromNib() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
