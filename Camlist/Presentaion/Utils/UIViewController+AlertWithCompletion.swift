//
//  UIViewController+AlertWithCompletion.swift
//  Camlist
//
//  Created by SherifShokry on 21/11/2021.
//

import Foundation
import UIKit

extension UIViewController{
    func areYouSureMsg(Msg : String , funcToLoad : @escaping ((Bool)->()) ){
        
        let alert = UIAlertController(title: Msg , message: "" , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: Strings.shared.no , style: UIAlertAction.Style.cancel , handler: {(UIAlertAction) in
            funcToLoad(false)
        }))
        alert.addAction(UIAlertAction(title: Strings.shared.yes , style: UIAlertAction.Style.default , handler: {(UIAlertAction) in
            funcToLoad(true)
            
        }
            
        ))
        self.present(alert, animated: true, completion: nil)
        
    }
}
