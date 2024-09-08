//
//  AppsViewState.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import Foundation

enum AppsViewState: Int {
    case preview
    case halfScreen
    case fullScreen
    
    var imageName: String {
        switch self {
        case .preview:
            return "rectangle.split.3x3"
        case .halfScreen:
            return "rectangle.split.2x1"
        case .fullScreen:
            return "rectangle"
        }
    }
}
