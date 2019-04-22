//
//  WeatherCollectionViewCell.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/20/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var hiTempLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
