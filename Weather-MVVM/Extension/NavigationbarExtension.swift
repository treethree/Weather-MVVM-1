//
//  NavigationbarExtension.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/23/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func makeNavbarClear() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        navigationBar?.tintColor = .white
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}
