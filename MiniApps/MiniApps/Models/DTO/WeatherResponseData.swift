//
//  WeatherResponseData.swift
//  MiniApps
//
//  Created by Evelina on 05.09.2024.
//

import Foundation

struct WeatherResponseData: Decodable {
    let weather: [Weather]
    let main: WeatherInfo
}

struct Weather: Decodable {
    let main: String
}

struct WeatherInfo: Decodable {
    let temp: Double
}
