//
//  AppsListPresenter.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import Foundation
import CoreLocation

protocol AppsListPresenterProtocol {
    func start()
}

final class AppsListPresenter: NSObject, AppsListPresenterProtocol, LocationServiceDelegateProtocol {
    private let weatherForecastService: WeatherForecastServiceProtocol
    private let locationService: LocationServiceProtocol
    
    weak var view: AppsListViewProtocol?
    private var userLocation: CLLocation?
    
    init(weatherForecastService: WeatherForecastServiceProtocol, locationService: LocationServiceProtocol) {
        self.weatherForecastService = weatherForecastService
        self.locationService = locationService
    }
    
    func start() {
        locationService.startLocation()
    }
    
    func didUpdateLocation(_ location: CLLocation) {
        Task {
            do {
                guard let city = await locationService.getUserCity(latitude: location.coordinate.latitude,
                                                                   longitude: location.coordinate.longitude)
                else {return}
                view?.updateLocation(city: city)
            }
        }
        Task {
            do {
                let weatherForcast = try await weatherForecastService.getWeatherByLatitudeAndLongitude(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude)
                view?.updateWeatherForecast(weatherForecast: weatherForcast)
            }
        }
    }
}
