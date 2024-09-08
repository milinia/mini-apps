//
//  CrosswordBlock.swift
//  MiniApps
//
//  Created by Evelina on 05.09.2024.
//

import Foundation
import UIKit

enum CrosswordBlockType: Equatable {
    case empty
    case start(Int)
    case regular
}

protocol CrosswordBlockDelegate: NSObject {
    func didTapped(block: CrosswordBlock)
    func didEnteredValue(block: CrosswordBlock)
}

final class CrosswordBlock: UIView {
    
    var enteredLetter: String = ""
    var blockBackgroundColor: UIColor = UIColor.white {
        didSet {
            backgroundColor = blockBackgroundColor
        }
    }
    weak var delegate: CrosswordBlockDelegate?
    
    private var type: CrosswordBlockType
    var id: Int
    var isGuessed: Bool = false {
        didSet {
            if isGuessed {
                self.isUserInteractionEnabled = false
                backgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
            }
        }
    }
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
    }
    
    // MARK: - UI properties
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 20
        textField.keyboardType = .alphabet
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Inits
    init(type: CrosswordBlockType = .regular, id: Int) {
        self.type = type
        self.id = id
        super.init(frame: CGRect())
        setupView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        delegate?.didTapped(block: self)
    }
    
    override init(frame: CGRect) {
        self.type = .regular
        self.id = 0
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    func selected() {
        textField.becomeFirstResponder()
        backgroundColor = UIColor.systemGray3
    }
    
    func unselected() {
        if !isGuessed {
            backgroundColor = UIColor.white
        }
    }
    
    // MARK: - Private functions
    private func setupView() {
        textField.delegate = self
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = blockBackgroundColor
        layer.cornerRadius = 20
        [numberLabel, textField].forEach({self.addSubview($0)})
        switch type {
        case .empty:
            numberLabel.isHidden = true
            textField.isHidden = true
            backgroundColor = .clear
        case .start(let int):
            numberLabel.text = String(int)
        case .regular:
            numberLabel.isHidden = true
        }
        numberLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
                    
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension CrosswordBlock: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let firstChar = string.first?.uppercased() {
            textField.text = String(firstChar)
            enteredLetter = String(firstChar)
            delegate?.didEnteredValue(block: self)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        handleTap()
    }
}
