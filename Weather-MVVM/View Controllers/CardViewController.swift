//
//  CardViewController.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/19/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var templBL: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var tomoTempLbl: UILabel!
    @IBOutlet weak var tomoIconImgView: UIImageView!
    @IBOutlet weak var tomoDescLbl: UILabel!
    
    var cardViewModel : CardViewModel!{
        didSet{
            DispatchQueue.main.async {
                self.colView.reloadData()
            }
        }
    }
    
    var weatherArrObj : [ForecastModel]!{
        didSet{
            DispatchQueue.main.async {
                self.colView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardViewModel = CardViewModel(services: WeatherApiHandler.sharedInstance)
        setupWeatherData()
        
        self.colView.register(UINib(nibName:"WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellIdentifier")
        
        self.colView.delegate = self
        self.colView.dataSource = self
        
        let layout = colView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 310)
        
    }
    
    func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
    
    func setupWeatherData(){
        cardViewModel.cityName = globalCityName
        cardViewModel.getWeatherData { (error) in
            guard error == nil else{
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.weatherArrObj = self.cardViewModel.weatherArr
            let signTemp = String(format:"%@", "\u{00B0}") as String
            self.descLbl.text = self.weatherArrObj![0].list[0].weather[0].main
            self.templBL.text = "\(String(Int(self.weatherArrObj![0].list[0].main.tempMax - 273.15)))/\(String(Int(self.weatherArrObj![0].list[0].main.tempMin - 273.15)))\(signTemp)C"
            self.setIconImage(imgView: self.iconImgView, iconName: self.weatherArrObj![0].list[0].weather[0].icon)
            
            self.tomoDescLbl.text = self.weatherArrObj![0].list[8].weather[0].main
            self.tomoTempLbl.text = "\(String(Int(self.weatherArrObj![0].list[8].main.tempMax - 273.15)))/\(String(Int(self.weatherArrObj![0].list[8].main.tempMin - 273.15)))\(signTemp)C"
            self.setIconImage(imgView: self.tomoIconImgView, iconName: self.weatherArrObj![0].list[8].weather[0].icon)
            
        }
    }
    
    func setIconImage(imgView : UIImageView ,iconName : String){
        let iconUrl = "http://openweathermap.org/img/w/%@.png"
        let urlString = String(format: iconUrl, arguments:[iconName])
        imgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image"))
    }
    

}

extension CardViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if weatherArrObj != nil{
            return (weatherArrObj[0].list.count / 8)
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! WeatherCollectionViewCell
        let signTemp = String(format:"%@", "\u{00B0}") as String
        
        
        if weatherArrObj != nil{
            if indexPath.item == 0{
                cell.weekLbl.text = "Today"
            }
            else if indexPath.item == 1{
                cell.weekLbl.text = "Tomorrow"
            }else{
                cell.weekLbl.text = getDayNameBy(stringDate: weatherArrObj[0].list[indexPath.item * 8].dtTxt)
            }
            
            cell.descLbl.text = weatherArrObj[0].list[indexPath.item * 8].weather[0].main
            cell.hiTempLbl.text = ("\(String(Int(weatherArrObj[0].list[indexPath.item * 8].main.tempMax - 273.15)))\(signTemp)C")
            cell.lowTempLbl.text = ("\(String(Int(weatherArrObj[0].list[indexPath.item * 8].main.tempMin - 273.15)))\(signTemp)C")
            setIconImage(imgView: cell.iconImgView, iconName: self.weatherArrObj![0].list[indexPath.item * 8].weather[0].icon)
        }
        

        return cell
    }
  
}
