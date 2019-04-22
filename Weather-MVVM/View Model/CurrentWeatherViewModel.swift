//
//  CurrentWeatherViewModel.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/18/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

class CurrentWeatherViewModel{
    var weatherArr : [WeatherModel]? = []
    var cityName : String = ""
    
    var weatherApiHandler : WeatherApiHandler
    
    init(services : WeatherApiHandler) {
        weatherApiHandler = services
    }
    
    
    func getWeatherData(completionHandler:@escaping ((String?)->Void)){
        
        
        weatherApiHandler.getApiForWeather(url: baseAPIUrl,city: cityName) {
            (weatherModel: WeatherModel?, error) in
            if let weatherModel = weatherModel{
                self.weatherArr?.append(weatherModel)
                completionHandler(nil)
            }else{
                completionHandler(error?.localizedDescription)
            }
        }
    }
}
