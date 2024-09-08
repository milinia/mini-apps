//
//  WeatherForecast.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import Foundation

struct WeatherForecast: Codable {
    let temp: Double
    let description: WeatherType
}

enum WeatherType: String, Codable {
    case snow = "Snow"
    case rain = "Rain"
    case sun = "Sun"
    case wind = "Wind"
    case clouds = "Clouds"
    
    var imageName: String {
        switch self {
        case .snow:
            return "snowIcon"
        case .rain:
            return "rainIcon"
        case .sun:
            return "sunIcon"
        case .wind:
            return "windIcon"
        case .clouds:
            return "cloudsIcon"
        }
    }
}
