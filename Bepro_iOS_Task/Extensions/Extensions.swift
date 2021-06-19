//
//  Extensions.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/22.
//

import Foundation
import UIKit
extension UIView {
    func addConstraintsWithVisualFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
