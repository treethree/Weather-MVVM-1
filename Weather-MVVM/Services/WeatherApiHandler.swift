//
//  WeatherApiHandler.swift
//  Weather-MVVM
//
//  Created by SHILEI CUI on 4/18/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

let baseAPIUrl = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=bac8f359973243cd39fb9e8f47977cc1"

let forecastAPIUrl = "https://api.openweathermap.org/data/2.5/forecast?q=%@&appid=bac8f359973243cd39fb9e8f47977cc1"

class WeatherApiHandler: NSObject {
    static let sharedInstance = WeatherApiHandler()
    private override init() {}
    
    func getApiForWeather<T: Codable>(url : String, city : String ,completion: @escaping (_ arrayWeather: T?, _ error: Error?) -> Void){
        
        let urlString1 = String(format: url, arguments:[city])
        let urlString = urlString1.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        guard let url = URL(string: urlString) else{
            return
        }
        URLSession.shared.dataTask(with : url){ (data, response, error) in
            if error == nil{
                do{
                    let result = try? JSONDecoder().decode(T.self, from: data!)
                    DispatchQueue.main.async {
                        completion(result,nil)
                    }
                }
            }
            }.resume()
    }
}
