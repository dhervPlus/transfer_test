//
//  ActivityIndicator.swift
//  naviboard-ios
//
//  Created by damien on 2019/10/10.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit


var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

extension UIView {
    func showActivityIndicatory() {
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            UIActivityIndicatorView.Style.gray
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}


