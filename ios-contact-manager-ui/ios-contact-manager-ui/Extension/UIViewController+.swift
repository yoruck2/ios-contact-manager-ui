//
//  UIViewController+.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/9/24.
//

import UIKit

extension UIViewController {
    func makeAlert(message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
