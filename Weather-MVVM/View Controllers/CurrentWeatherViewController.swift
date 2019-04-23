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
    
    private var roundButton = UIButton()
    var topContForBtn : Float = 0
    
    var currentWeatherViewModel : CurrentWeatherViewModel = CurrentWeatherViewModel(services: WeatherApiHandler.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CurrentWeatherViewController.tapFunction))
        startLbl.isUserInteractionEnabled = true
        startLbl.addGestureRecognizer(tap)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        if currentWeatherViewModel.weatherArr?.count != 0{
            createFloatingButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                //roundButton = nil
                self.roundButton.isHidden = true
            }
        }
    }
    
    @objc func addBtnClicked(){
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
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"plus_image"), for: .normal)
        // Make sure to create a function and replace DOTHISONTAP with your own function:
        roundButton.addTarget(self, action: #selector(addBtnClicked), for: UIControl.Event.touchUpInside)
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {


            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.topAnchor.constraint(equalTo: self.roundButton.topAnchor, constant: CGFloat(self.topContForBtn)),
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 25),
//                    self.roundButton.rightAnchor.constraint(equalTo: self.tblView.safeAreaLayoutGuide.rightAnchor, constant: -10),
//                    self.roundButton.bottomAnchor.constraint(equalTo: self.tblView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 55),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 55)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = 27.5
            // Add a black shadow:
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            // Add a pulsing animation to draw attention to button:
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.4
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
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
        //cell?.addBtnOutlet.tag = indexPath.row

        cell?.cityNameLbl.text = weatherObj.name
        //convert kelvin to celsius
        let signTemp = String(format:"%@", "\u{00B0}") as String

        cell?.hiTempLbl.text = "\(String(Int(weatherObj.main.tempMax - 273.15)))\(signTemp)C "
        cell?.lowTempLbl.text = "\(String(Int(weatherObj.main.tempMin - 273.15)))\(signTemp)C"

        cell?.setIconImage(iconName: weatherObj.weather[0].icon)
        
//        cell?.setUpCurrentWeatherData(city: weatherObj.name, hiTemp: weatherObj.main.tempMax, loTemp: weatherObj.main.tempMin, iconImg: weatherObj.weather[0].icon)
        
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

        if self.currentWeatherViewModel.weatherArr!.count == 0{
            self.topContForBtn = -175
        }else{
            if self.topContForBtn < -610{
                self.topContForBtn = -610
            }else{
                self.topContForBtn = Float(-175 - (self.currentWeatherViewModel.weatherArr!.count * 145))
            }
        }
        
        createFloatingButton()
        
        
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
