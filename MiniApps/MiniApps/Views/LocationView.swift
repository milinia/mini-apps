//
//  LocationView.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import UIKit
import Foundation

class LocationView: AppView {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let currentLocationTitleLabelFontSize: CGFloat = 14
        static let currentLocationTitleLabelNumberOfLines: Int = 1
        static let currentLocationLabelFontSize: CGFloat = 24
        static let currentLocationLabelNumberOfLines: Int = 2
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
    private lazy var currentLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.currentLocationTitleLabelFontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = UIConstants.currentLocationTitleLabelNumberOfLines
        label.text = "Current location"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.currentLocationLabelFontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = UIConstants.currentLocationLabelNumberOfLines
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
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Inits
    
    override init(state: AppsViewState) {
        super.init(state: state)
        setupView()
        loadingView.startAnimating()
        vStack.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setupView() {
        backgroundColor = UIColor(named: "baseColor")
        layer.cornerRadius = UIConstants.viewCornerRadius
        
        [currentLocationTitleLabel, currentLocationLabel].forEach({vStack.addArrangedSubview($0)})
        [vStack, loadingView].forEach({addSubview($0)})
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.contentInset),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.contentInset),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.contentInset),
            vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.contentInset),
            
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func updateLabelColors() {
        currentLocationTitleLabel.textColor = labelColor
        currentLocationLabel.textColor = labelColor
    }
    
    private func updateBackgroundColor() {
        backgroundColor = viewBackgroundColor
    }
    
    // MARK: - Public functions
    func setCity(with city: String) {
        currentLocationLabel.text = city
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseInOut) {
            self.loadingView.stopAnimating()
            self.vStack.isHidden = false
        }
    }
}
