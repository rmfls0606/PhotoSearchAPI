//
//  ViewController+Extension.swift
//  PhotoSearchAPI
//
//  Created by 이상민 on 1/22/25.
//

import UIKit

extension UIViewController{
    func showAlert(statusCode: Int){
        var title = "Error"
        var message = ""
        
        switch statusCode{
        case 200:
            title = "Success"
            message = "Everything worked as expected."
        case 400:
            message = "The request was unacceptable, often due to missing a required parameter."
        case 401:
            message = "Invalid Access Token."
        case 403:
            message = "Missing permissions to perform request."
        case 404:
            message = "The requested resource doesn't exist."
        case 500, 503:
            message = "Something went wrong on our end."
        default:
            message = "An unexpected error occurred. Please try again."
        }
        
        let alert = UIAlertController(title: "\(title) \(statusCode)", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}
