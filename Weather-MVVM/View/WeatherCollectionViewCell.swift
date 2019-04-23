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
    
//    func setupFiveDaysData(week : String, desc : String, hiTemp: Double, lowTemp: Double, iconImg : String){
//        weekLbl.text = week
//        descLbl.text = desc
//        hiTempLbl.text = hiTemp
//        lowTempLbl.text = lowTemp
//        setIconImage(iconName: iconImg)
//    }
    
    func setIconImage(iconName : String){
        let iconUrl = "http://openweathermap.org/img/w/%@.png"
        let urlString = String(format: iconUrl, arguments:[iconName])
        iconImgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image"))
    }
}
