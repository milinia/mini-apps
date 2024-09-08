//
//  AppView.swift
//  MiniApps
//
//  Created by Evelina on 04.09.2024.
//

import Foundation
import UIKit

class AppView: UIView {
    
    var state: AppsViewState {
        didSet {
            updateState()
        }
    }
    
    private func updateState() {
        switch state {
        case .preview:
            previewState()
        case .fullScreen:
            fullScreenState()
        case .halfScreen:
            halfScreenState()
        }
    }
    
    func previewState() {
        self.isUserInteractionEnabled = false
    }
    
    func fullScreenState() {
        self.isUserInteractionEnabled = true
    }
    
    func halfScreenState() {
        self.isUserInteractionEnabled = true
    }
    
    init(state: AppsViewState) {
        self.state = state
        super.init(frame: CGRect())
        updateState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
