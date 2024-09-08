//
//  AppsListViewController.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import UIKit

protocol AppsListViewProtocol: NSObject {
    func updateWeatherForecast(weatherForecast: WeatherForecast)
    func updateLocation(city: String)
}

class AppsListViewController: UIViewController {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
    }
    
    private var weatherForecastView1 = WeatherForecastView(state: .preview)
    private var weatherForecastView2 = WeatherForecastView(state: .preview)
    private var weatherForecastView3 = WeatherForecastView(state: .preview)
    private var weatherForecastView4 = WeatherForecastView(state: .preview)
    
    private var locationView1 = LocationView(state: .preview)
    private var locationView2 = LocationView(state: .preview)
    private var locationView3 = LocationView(state: .preview)
    private var crossword1 = CrosswordView(state: .preview, rows: 4, columns: 5, words: [Word(start: 1, end: 4, value: "TEST", axis: .horizontal, question: "An examination or assessment to evaluate knowledge or skills."), Word(start: 4, end: 19, value: "TAPE", axis: .vertical, question: "Sticky strip used for fastening or sealing things"), Word(start: 18, end: 20, value: "PEN", axis: .horizontal, question: "A tool used for writing, typically filled with ink.")])
    
    private var crossword2 = CrosswordView(state: .preview, rows: 3, columns: 3, words: [Word(start: 2, end: 8, value: "WAY", axis: .vertical, question: "Path or method to reach a destination or achieve something"), Word(start: 4, end: 6, value: "CAT", axis: .horizontal, question: "Small, furry animal known for its agility and love for chasing mice")])
    
    private var crossword3 = CrosswordView(state: .preview, rows: 5, columns: 6, words: [Word(start: 1, end: 6, value: "forest", axis: .horizontal, question: "A large area covered chiefly with trees and undergrowth."), Word(start: 6, end: 18, value: "tea", axis: .vertical, question: "Beverage often enjoyed with a splash of milk"), Word(start: 19, end: 23, value: "ocean", axis: .horizontal, question: "A vast body of salt water that covers almost all Earth's surface."), Word(start: 3, end: 27, value: "river", axis: .vertical, question: "A large natural stream of water flowing in a channel to the sea")])
    
    // MARK: - Private properties
    private var appsListShowingState: AppsViewState = .preview
    private var apps: [AppView] = []
    private var presenter: AppsListPresenterProtocol
    
    // MARK: - Inits
    init(presenter: AppsListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        apps = [crossword1, weatherForecastView4, locationView1, crossword3, locationView2, weatherForecastView1, weatherForecastView2, weatherForecastView3, locationView3, crossword2]
        weatherForecastView1.labelColor = .black
        weatherForecastView1.viewBackgroundColor = .lightGray
        locationView1.labelColor = .green
        locationView1.viewBackgroundColor = .darkGray
        crossword2.viewBackgroundColor = .darkGray
        crossword2.labelsTextColor = .systemGreen
        crossword3.viewBackgroundColor = .lightGray
        crossword3.labelsTextColor = .black
        locationView3.labelColor = .black
        locationView3.viewBackgroundColor = .lightGray
        weatherForecastView3.labelColor = .systemGreen
        weatherForecastView3.viewBackgroundColor = .darkGray
        weatherForecastView4.viewBackgroundColor = .systemBrown.withAlphaComponent(0.8)
        weatherForecastView4.labelColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI properties
    private lazy var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var showAppsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: appsListShowingState.imageName), style: .plain, target: self, action: #selector(buttonTapped))
        button.tintColor = .black
        return button
    }()
    
    @objc func buttonTapped() {
        appsListShowingState = appsListShowingState == .fullScreen ? .preview : AppsViewState(rawValue: appsListShowingState.rawValue + 1) ?? .preview
        showAppsButton.image = UIImage(systemName: appsListShowingState.imageName)
        apps.forEach({$0.state = appsListShowingState})
        appsCollectionView.reloadData()
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = showAppsButton
        view.backgroundColor = .white
        setupSubview()
        setupConstraints()
        presenter.start()
    }

    // MARK: - Private functions
    private func setupSubview() {
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(AppViewCell.self, forCellWithReuseIdentifier: String(describing: AppViewCell.self))
    }
    
    private func setupConstraints() {
        view.addSubview(appsCollectionView)
        NSLayoutConstraint.activate([
            appsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.contentInset),
            appsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.contentInset),
            appsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.contentInset),
            appsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIConstants.contentInset)
        ])
    }
}

// MARK: - Implement UICollectionViewDelegate, UICollectionViewDataSource
extension AppsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = appsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AppViewCell.self), for: indexPath) as? AppViewCell else {return UICollectionViewCell()}
        cell.setAppForCell(appView: apps[indexPath.row])
        return cell
    }
}

// MARK: - Implement UICollectionViewDelegateFlowLayout
extension AppsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let divider: CGFloat
        switch self.appsListShowingState {
        case .fullScreen:
            divider = 1
        case .halfScreen:
            divider = 2
        case .preview:
            divider = 8
        }
        let itemHeight = collectionView.bounds.height / divider
        let itemWidth = collectionView.bounds.width
        return CGSize(width: Double(itemWidth), height: Double(itemHeight))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIConstants.contentInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIConstants.contentInset
    }
}

// MARK: - Implement AppsListViewProtocol
extension AppsListViewController: AppsListViewProtocol {
    func updateWeatherForecast(weatherForecast: WeatherForecast) {
        apps.forEach { view in
            if let weatherView = view as? WeatherForecastView {
                DispatchQueue.main.async {
                    weatherView.setWeatherForecast(with: weatherForecast)
                }
            }
        }
        DispatchQueue.main.async {
            self.appsCollectionView.reloadData()
        }
    }
    
    func updateLocation(city: String) {
        apps.forEach { view in
            if let locationView = view as? LocationView {
                DispatchQueue.main.async {
                    locationView.setCity(with: city)
                }
            }
        }
        DispatchQueue.main.async {
            self.appsCollectionView.reloadData()
        }
    }
}
