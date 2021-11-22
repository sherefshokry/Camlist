//
//  UIViewController+ShowAlertMsg.swift
//  Camlist
//
//  Created by SherifShokry on 21/11/2021.
//

import Foundation
import UIKit


extension UIViewController{
     
    func showMessage(_ message: String) -> Void {
      
       let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
             switch action.style{
             case .default:
                alert.dismiss(animated: true, completion: nil)
             case .cancel:
                   alert.dismiss(animated: true, completion: nil)

             case .destructive:
                   alert.dismiss(animated: true, completion: nil)
             @unknown default:
                 alert.dismiss(animated: true, completion: nil)
             }}))
       self.present(alert, animated: true, completion: nil)
    }
    
    
}
