//
//  LoadingView.swift
//  covid info
//
//  Created by Alex Rudoi on 11/10/21.
//

import Foundation
import UIKit

class LoadingView {
    
    let activityView = UIActivityIndicatorView(style: .medium)
    
    public static func show() {
        UIApplication.topViewController()
    }
    
}
