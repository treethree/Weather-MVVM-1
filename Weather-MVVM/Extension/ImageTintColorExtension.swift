//
//  ImageTintColorExtension.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/20/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func tintImageColor(color: UIColor) {
        guard let image = image else { return }
        self.image = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.tintColor = color
    }
    
}
