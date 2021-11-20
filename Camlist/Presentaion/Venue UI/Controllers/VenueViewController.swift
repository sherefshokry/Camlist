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
    
    var venueUpdateController: VenueUpdateViewController?
    var venueItems: [VenueCellController] = [] {
        didSet{
            DispatchQueue.main.async{ [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var hasError: Bool = false {
        didSet{  DispatchQueue.main.async{ [weak self] in
            self?.errorDataView.isHidden = !self!.hasError
          }
    }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        venueUpdateController?.loadVenueData()
    }
    
}

extension VenueViewController: UITableViewDataSource,UITableViewDelegate {
    
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
        venueItems[indexPath.row].releaseCell()
    }
    
}
