//
//  UIAlertControllerExtension.swift
//  NYCSchools
//
//  Created by Sheetal on 2/24/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle:String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
