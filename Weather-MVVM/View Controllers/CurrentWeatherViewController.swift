//
//  CurrentWeatherViewController.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/18/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit
import SDWebImage
import GooglePlaces

var globalCityName : String = ""

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var startLbl: UILabel!
    
    var currentWeatherViewModel : CurrentWeatherViewModel = CurrentWeatherViewModel(services: WeatherApiHandler.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CurrentWeatherViewController.tapFunction))
        startLbl.isUserInteractionEnabled = true
        startLbl.addGestureRecognizer(tap)
        
        
        //navigationController?.isNavigationBarHidden = true
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
        startLbl.isHidden = true
    }

    
    @IBAction func addBtnClick(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)

        sender.isHidden = true
    }
}


extension CurrentWeatherViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = currentWeatherViewModel.weatherArr?.count
        return numberOfRows ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell") as? CurrentWeatherTableViewCell
        
        let weatherArrObj = currentWeatherViewModel.weatherArr
        let weatherObj = weatherArrObj![indexPath.row]
        cell?.addBtnOutlet.tag = indexPath.row

        cell?.cityNameLbl.text = weatherObj.name
        //convert kelvin to celsius
        let signTemp = String(format:"%@", "\u{00B0}") as String
        
        cell?.hiTempLbl.text = "\(String(Int(weatherObj.main.tempMax - 273.15)))\(signTemp)C "
        cell?.lowTempLbl.text = "\(String(Int(weatherObj.main.tempMin - 273.15)))\(signTemp)C"

        cell?.setIconImage(iconName: weatherObj.weather[0].icon)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let weatherArrObj = currentWeatherViewModel.weatherArr
        let weatherObj = weatherArrObj![indexPath.row]
        let signTemp = String(format:"%@", "\u{00B0}") as String
        
        vc?.temp = "\(String(Int(weatherObj.main.temp - 273.15)))\(signTemp) "
        vc?.desc = weatherObj.weather[0].main
        vc?.city = weatherObj.name
        vc?.wind = "\(String(Int(weatherObj.wind.speed)))m/s"
        vc?.hilowTemp = "\(String(Int(weatherObj.main.tempMax - 273.15)))/\(String(Int(weatherObj.main.tempMin - 273.15)))\(signTemp)C"
        
        globalCityName = weatherObj.name
        navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension CurrentWeatherViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        currentWeatherViewModel.cityName = place.name!
        
        currentWeatherViewModel.getWeatherData { (error) in
            guard error == nil else{
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            //reload table view
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        
//        print("Place name: \(place.name)")
//        print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
