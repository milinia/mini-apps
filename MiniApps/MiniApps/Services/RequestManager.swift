//
//  Requests.swift
//  MiniApps
//
//  Created by Evelina on 04.09.2024.
//

import Foundation

enum Requests {
    case search(searchRequest: String)
    
    var baseUrl: String {
        return "https://api.openweathermap.org/data/2.5/weather"
    }
    var apiKey: String {
        return "d374c6afe9552dc37f37ea9581537206"
    }
}
