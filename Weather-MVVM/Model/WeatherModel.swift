//
//  WeatherModel.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/18/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

struct ForecastModel: Codable {
    let cnt: Int
    let list: [List]
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case dtTxt = "dt_txt"
    }
}

struct Main: Codable {
    let temp: Double
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}


struct Weather: Codable {
    let main : String
    let icon : String
}

struct Wind: Codable {
    let speed: Double
}
