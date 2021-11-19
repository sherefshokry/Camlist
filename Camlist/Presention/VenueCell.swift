//
//  VenueCell.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import Foundation
import UIKit


class VenueCell: UITableViewCell{
    @IBOutlet weak var venueImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        venueImage.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        venueImage.alpha = 0
    }

    func fadeIn(image: UIImage){
        self.venueImage.image = image
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: []) {
            self.venueImage.alpha = 1
        }

    }
    
}
