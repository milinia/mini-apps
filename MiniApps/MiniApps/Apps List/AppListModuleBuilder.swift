//
//  AppListModuleBuilder.swift
//  MiniApps
//
//  Created by Evelina on 05.09.2024.
//

import Foundation
import UIKit
import CoreLocation

protocol ModuleBuilderProtocol {
    static func build() -> UIViewController
}

final class AppListModuleBuilder: ModuleBuilderProtocol {
    static func build() -> UIViewController {
        let locationService = LocationService(locationManager: CLLocationManager())
        let presenter = AppsListPresenter(weatherForecastService: WeatherForecastService(networkManager: NetworkManager()), locationService: locationService)
        locationService.delegate = presenter
        let view = AppsListViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
