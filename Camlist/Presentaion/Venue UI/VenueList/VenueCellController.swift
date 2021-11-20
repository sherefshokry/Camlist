//
//  VenueCellViewController.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//

import Foundation
import UIKit

final class VenueCellController {
    
    private var model: Venue
    //private var useCase: FetchVenueImageUseCase
//    , useCase: FetchVenueImageUseCase
    init(model: Venue) {
        self.model = model
       // self.useCase = useCase
    }
     
    
    func view(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let venueCell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell
        venueCell.titleLabel.text = model.name
        venueCell.addressLabel.text = model.location.address
        venueCell.fadeIn(image: UIImage(named: "address_icon")!)
        return venueCell
    }
    
    
    
}
