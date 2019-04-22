//
//  WeatherModel.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/18/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

import Foundation

struct WeatherModel: Codable {
    //let coord: Coord
    let weather: [Weather]
//    let base: String
    let main: Main
//    let visibility: Int
    let wind: Wind
    //let clouds: Clouds
//    let dt: Int
    //let sys: Sys
//    let id: Int
    let name: String
//    let cod: Int
    
    //let list: [List]
}

struct ForecastModel: Codable {
    //let cod: String
    //let message: Double
    let cnt: Int
    let list: [List]
    //let city: City
}

struct List: Codable {
    //let dt: Int
    let main: Main
    let weather: [Weather]
//    let clouds: Clouds
    let wind: Wind
//    let rain: Rain?
//    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        //case dt, main, weather, clouds, wind, rain, sys
        case main, weather, wind
        case dtTxt = "dt_txt"
    }
}

//struct MainClass: Codable {
//    let temp, tempMin, tempMax, pressure: Double
//    let seaLevel, grndLevel: Double
//    let humidity: Int
//    let tempKf: Double
//
//    enum CodingKeys: String, CodingKey {
//        case temp
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
//        case humidity
//        case tempKf = "temp_kf"
//    }
//}

//struct Clouds: Codable {
//    let all: Int
//}
//
//struct Coord: Codable {
//    let lon, lat: Double
//}

struct Main: Codable {
    let temp: Double
    //let pressure, humidity: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        //case temp, pressure, humidity
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

//struct Sys: Codable {
//    let type, id: Int
//    let message: Double
//    let country: String
//    let sunrise, sunset: Int
//}

struct Weather: Codable {
//    let id: Int
//    let main, description, icon: String
    let main : String
    let icon : String
}

struct Wind: Codable {
    let speed: Double
//    let deg: Int
//    let gust: Double
}
