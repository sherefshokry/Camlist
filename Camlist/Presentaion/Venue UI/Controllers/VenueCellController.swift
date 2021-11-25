//
//  VenueCellViewController.swift
//  Camlist
//
//  Created by SherifShokry on 19/11/2021.
//
import Foundation
import UIKit
import SDWebImage

final class VenueCellController{

    private var venueCell: VenueCell?
    private let viewModel: VenueCellViewModel
    
    
    init(viewModel: VenueCellViewModel) {
        self.viewModel = viewModel
    }
    
    
    func view(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell") as! VenueCell
        venueCell = binded(cell)
        viewModel.loadImageData()
        return venueCell!
    }
    
    func binded(_ cell: VenueCell) -> VenueCell {
        cell.titleLabel.text = viewModel.venueName
        cell.addressLabel.text = viewModel.venueAddress
        
        viewModel.onImageLoad = {[weak cell] imageUrl in
            cell?.venueImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "address_icon"), completed: nil)
        }
        
        
        viewModel.onImageFailedToLoad = {[weak cell] _ in
            DispatchQueue.main.async {
                cell?.venueImage.image = UIImage(named: "address_icon")
            } 
        }
        
        return cell
    }
    
    func cancelLoad(){
        releaseCell()
        viewModel.cancelImageDataLoad()
    }
    
    
    func preload(){
        viewModel.loadImageData()
    }
    
    
    func releaseCell(){
        venueCell = nil
    }
    
    
}
