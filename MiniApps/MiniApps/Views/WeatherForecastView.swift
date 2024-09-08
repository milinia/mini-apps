//
//  WeatherForecastView.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import UIKit
import Foundation

final class WeatherForecastView: AppView {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let labelsFontSize: CGFloat = 24
        static let labelsNumberOfLines: Int = 2
        static let viewCornerRadius: CGFloat = 20
    }
    
    // MARK: - Public properties
    var labelColor: UIColor = .white {
        didSet {
            updateLabelColors()
        }
    }
    var viewBackgroundColor: UIColor = UIColor(named: "baseColor") ?? .gray {
        didSet {
            updateBackgroundColor()
        }
    }
    
    // MARK: - UI properties
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = labelColor
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.labelsFontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = UIConstants.labelsNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = labelColor
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.labelsFontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = UIConstants.labelsNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Inits
    
    override init(state: AppsViewState) {
        super.init(state: state)
        setupView()
        loadingView.startAnimating()
        hStack.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setupView() {
        backgroundColor = viewBackgroundColor
        layer.cornerRadius = UIConstants.viewCornerRadius
        
        let hStackTempImage = UIStackView()
        hStackTempImage.translatesAutoresizingMaskIntoConstraints = false
        hStackTempImage.axis = .horizontal
        hStackTempImage.distribution = .fillEqually
        [tempLabel, weatherImage].forEach({hStackTempImage.addArrangedSubview($0)})
        [weatherDescriptionLabel, hStackTempImage].forEach({hStack.addArrangedSubview($0)})
        [hStack, loadingView].forEach({addSubview($0)})
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.contentInset),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.contentInset),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.contentInset),
            hStack.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.contentInset),
            
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func updateLabelColors() {
        weatherDescriptionLabel.textColor = labelColor
        tempLabel.textColor = labelColor
    }
    
    private func updateBackgroundColor() {
        backgroundColor = viewBackgroundColor
    }
    
    // MARK: - Public functions
    func setWeatherForecast(with forecast: WeatherForecast) {
        tempLabel.text = String(Int(forecast.temp)) + "°C"
        weatherDescriptionLabel.text = forecast.description.rawValue
        weatherImage.image = UIImage(named: forecast.description.imageName)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseInOut) {
            self.loadingView.stopAnimating()
            self.hStack.isHidden = false
        }
    }
}
