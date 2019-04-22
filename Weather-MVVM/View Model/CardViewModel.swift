//
//  CardViewModel.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/20/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

class CardViewModel{
    var weatherArr : [ForecastModel]? = []
    var cityName : String = ""
    
    var weatherApiHandler : WeatherApiHandler
    
    init(services : WeatherApiHandler) {
        weatherApiHandler = services
    }
    
    func getWeatherData(completionHandler:@escaping ((String?)->Void)){
        weatherApiHandler.getApiForWeather(url: forecastAPIUrl,city: cityName) { (weatherModel : ForecastModel?, error) in
            if let weatherModel = weatherModel{
                self.weatherArr?.append(weatherModel)
                completionHandler(nil)
            }else{
                completionHandler(error?.localizedDescription)
            }
        }
    }
}
