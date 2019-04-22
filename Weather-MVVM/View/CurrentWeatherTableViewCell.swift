//
//  CurrentWeatherTableViewCell.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/18/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import SDWebImage

class CurrentWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var addBtnOutlet: UIButton!
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var hiTempLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
          bgView.setGradientBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setIconImage(iconName : String){
        let iconUrl = "http://openweathermap.org/img/w/%@.png"
        let urlString = String(format: iconUrl, arguments:[iconName])
        iconImgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image"))
    }

}
