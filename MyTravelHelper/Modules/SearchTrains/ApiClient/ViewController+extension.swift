//
//  ViewController+extension.swift
//  MyTravelHelper
//
//  Created by Vinoth on 19/10/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String = "" , actionTitle: String = "Okay") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
