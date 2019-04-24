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
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var startLbl: UILabel!
    
    private var roundButton = UIButton()
    var topContForBtn : Float = 0
    
    var currentWeatherViewModel : CurrentWeatherViewModel = CurrentWeatherViewModel(services: WeatherApiHandler.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CurrentWeatherViewController.tapFunction))
        startLbl.isUserInteractionEnabled = true
        startLbl.addGestureRecognizer(tap)
        
        makeNavbarClear()
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
    
    @IBAction func addBtnClick(_ sender: Any) {
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
    }
    
    func setupFloatButton(){
        addBtn.backgroundColor = .white
        addBtn.setImage(UIImage(named:"plus_image"), for: .normal)
        addBtn.widthAnchor.constraint(equalToConstant: 75)
        addBtn.heightAnchor.constraint(equalToConstant: 75)
        addBtn.layer.cornerRadius = 37.5
        // Add a black shadow:
        addBtn.layer.shadowColor = UIColor.black.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        addBtn.layer.masksToBounds = false
        addBtn.layer.shadowRadius = 2.0
        addBtn.layer.shadowOpacity = 0.5
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
        
        cell?.setUpCurrentWeatherData(city: weatherObj.name, hiTemp: weatherObj.main.tempMax, loTemp: weatherObj.main.tempMin, iconImg: weatherObj.weather[0].icon)
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let weatherArrObj = currentWeatherViewModel.weatherArr
        let weatherObj = weatherArrObj![indexPath.row]
        vc?.setupDetailViewData(temp: weatherObj.main.temp, city: weatherObj.name, desc: weatherObj.weather[0].main, wind: weatherObj.wind.speed, hiTemp: weatherObj.main.tempMax, lowTemp: weatherObj.main.tempMin)

        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.currentWeatherViewModel.weatherArr?.remove(at: indexPath.row)
            //self.catNames.remove(at: indexPath.row)
            self.tblView.deleteRows(at: [indexPath], with: .automatic)
        }
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
        
        setupFloatButton()
        
        
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
