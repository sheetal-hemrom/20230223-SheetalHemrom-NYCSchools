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
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "loading ...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
    }
    
    func hideLoader() {
        if let alertVC = self.navigationController?.presentedViewController, alertVC is UIAlertController{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                alertVC.dismiss(animated: false, completion: nil)
            }
        }
    }
}
