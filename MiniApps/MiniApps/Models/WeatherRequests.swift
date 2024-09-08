//
//  WeatherRequests.swift
//  MiniApps
//
//  Created by Evelina on 04.09.2024.
//

import Foundation

enum WeatherRequests {
    case weatherForecastRequest(latitude: String, longitude: String)
    
    var baseUrl: String {
        return "https://api.openweathermap.org/data/2.5"
    }
    var apiKey: String {
        return "d374c6afe9552dc37f37ea9581537206"
    }
    
    var url: String {
        switch self {
        case .weatherForecastRequest(let latitude, let longitude):
            return baseUrl + "/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
    }
}
