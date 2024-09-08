//
//  AppViewCell.swift
//  MiniApps
//
//  Created by Evelina on 04.09.2024.
//

import Foundation
import UIKit

class AppViewCell: UICollectionViewCell {
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func initialize() {
        backgroundColor = .clear
    }
    
    // MARK: - Public functions
    func setAppForCell(appView: AppView) {
        appView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(appView)
        NSLayoutConstraint.activate([
            appView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            appView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            appView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            appView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
