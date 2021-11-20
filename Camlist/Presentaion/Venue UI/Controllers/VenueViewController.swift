//
//  ViewController.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import UIKit

final class VenueViewController: UIViewController , StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorDataView: UIStackView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    
    var venueUpdateController: VenueUpdateViewController?
    var venueItems: [VenueCellController] = [] {
        didSet{
            DispatchQueue.main.async{ [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    func displayErrorView(with errorTitle: String){
        DispatchQueue.main.async { [weak self] in
            self?.errorDataView.isHidden = false
            self?.errorTitleLabel.text = errorTitle
        }
    }
    
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        venueUpdateController?.loadVenueData()
    }
    
}

extension VenueViewController: UITableViewDataSource,UITableViewDelegate,UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return venueItems[indexPath.row].view(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        venueItems[indexPath.row].cancelLoad()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        venueItems[indexPath.row].preload()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
         _ = venueItems[indexPath.row]
        }
    }
    
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            venueItems[indexPath.row].cancelLoad()
        }
    }
    
    
    
}
