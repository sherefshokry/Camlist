//
//  ViewController.swift
//  Camlist
//
//  Created by SherifShokry on 18/11/2021.
//

import UIKit

enum AppStatus: String {
    case realTime = "Realtime"
    case singleUpdate = "Single Update"
}


final class VenueViewController: UIViewController , StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorDataView: UIStackView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    
    var reloadVenueList: (() -> Void)?
    
    var venueUpdateController: VenueUpdateViewController?
    var venueItems: [VenueCellController] = [] {
        didSet{
           DispatchQueue.main.async{ [weak self] in
               self?.tableView.reloadData()
           }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        venueUpdateController?.setLoadingView(with: self.view)
        venueUpdateController?.loadVenueData()
        setupNavigationItem()
    }
    
    
    func setupNavigationItem(){
        self.navigationItem.title = Constants.Strings.NEAR_BY
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: Utils.getAppStatus() == .realTime ?  Constants.Strings.REAL_TIME : Constants.Strings.SINGLE_UPDATE, style: .plain , target: self, action: #selector(self.action(sender:)))
   
    }
    
    @objc func action(sender: UIBarButtonItem){
        let currentStatus = Utils.getAppStatus()
        let alertMsg = currentStatus == .realTime ?  Constants.Strings.SINGLE_UPDATE_MSG : Constants.Strings.REALTIME_MSG
        
        self.areYouSureMsg(Msg: alertMsg) {[weak self] yes in
            if yes{
                Utils.setAppStatus(isRealTime: currentStatus == .realTime ? false : true)
                self?.navigationItem.rightBarButtonItem?.title =  currentStatus == .realTime ? Constants.Strings.SINGLE_UPDATE : Constants.Strings.REAL_TIME
                self?.reloadVenueList?()
            }
        }
    }
   
    func displayErrorView(with errorTitle: String){
        DispatchQueue.main.async { [weak self] in
            self?.errorDataView.isHidden = false
            self?.errorTitleLabel.text = errorTitle
        }
    }
    
    func hideErrorView(){
        DispatchQueue.main.async { [weak self] in
            self?.errorDataView.isHidden = true
        }
    }
}

extension VenueViewController: UITableViewDataSource,UITableViewDelegate {
//    ,UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return venueItems[indexPath.row].view(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        venueItems[indexPath.row].cancelLoad()
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        venueItems[indexPath.row].preload()
//    }
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        indexPaths.forEach { indexPath in
//         _ = venueItems[indexPath.row]
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        indexPaths.forEach { indexPath in
//            venueItems[indexPath.row].cancelLoad()
//        }
//    }
    
    
    
}
