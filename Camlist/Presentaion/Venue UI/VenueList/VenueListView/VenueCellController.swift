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
    private var useCase: FetchVenueImageUseCase

    init(model: Venue, useCase: FetchVenueImageUseCase) {
        self.model = model
        self.useCase = useCase
    }
     
    
    func view(tableView: UITableView,indexPath: IndexPath) -> UITableViewCell {
        let venueCell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell
        venueCell.titleLabel.text = model.name
        venueCell.addressLabel.text = model.location.address
        useCase.execute(venueId: model.id) {[weak self] result in
            switch result{
            case let .success(venueImages):
                print("\(self?.model.id) , \(venueImages.count)")
               // venueCell.fadeIn(image: <#T##UIImage#>)
            case  .failure(_):
                venueCell.fadeIn(image: UIImage(named: "address_icon")!)
            }
        }
       
        return venueCell
    }

    
}
