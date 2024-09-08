//
//  Word.swift
//  MiniApps
//
//  Created by Evelina on 06.09.2024.
//

import Foundation

enum Axis {
    case vertical
    case horizontal
}

struct Word {
    let start: Int
    let end: Int
    let value: String
    let axis: Axis
    let question: String
}
