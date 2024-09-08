//
//  QuestionTableViewCell.swift
//  MiniApps
//
//  Created by Evelina on 07.09.2024.
//

import Foundation
import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    var labelTextColor: UIColor = .white {
        didSet {
            self.questionLabel.textColor = labelTextColor
        }
    }
    
    // MARK: - Private constants
    private enum UIConstants {
        static let questionLabelFontSize: CGFloat = 18
        static let questionLabelNumberOfLines: Int = 2
        static let topInset: CGFloat = 6
    }
    
    // MARK: - Private UI properties
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: UIConstants.questionLabelFontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = UIConstants.questionLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private functions
    private func initialize() {
        backgroundColor = .clear
        addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            questionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.topInset)
        ])
    }
    
    // MARK: - Public functions
    func setQuestionForCell(question: String, index: Int) {
        questionLabel.text = "\(index + 1) - " + question
    }
}
