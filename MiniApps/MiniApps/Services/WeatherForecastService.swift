//
//  WeatherForecastService.swift
//  MiniApps
//
//  Created by Evelina on 04.09.2024.
//

import Foundation

protocol WeatherForecastServiceProtocol {
    func getWeatherByLatitudeAndLongitude(latitude: Double, longitude: Double) async throws -> WeatherForecast
}

final class WeatherForecastService: WeatherForecastServiceProtocol {
    
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - Implement WeatherForecastServiceProtocol
    func getWeatherByLatitudeAndLongitude(latitude: Double, longitude: Double) async throws -> WeatherForecast {
        let data = try await networkManager.makeRequest(with: WeatherRequests.weatherForecastRequest(
            latitude: String(latitude),
            longitude: String(longitude)).url)
        let weatherData = try JSONDecoder().decode(WeatherResponseData.self, from: data)
        let weatherForecast = WeatherForecast(temp: weatherData.main.temp,
                                              description: WeatherType(rawValue: weatherData.weather[0].main) ?? WeatherType.sun)
        return weatherForecast
    }
}
