//
//  CrosswordView.swift
//  MiniApps
//
//  Created by Evelina on 05.09.2024.
//

import Foundation
import UIKit

final class CrosswordView: AppView {
    
    // MARK: - Public properties
    var viewBackgroundColor: UIColor = UIColor(named: "baseColor") ?? .gray {
        didSet {
            self.backgroundColor = viewBackgroundColor
        }
    }
    
    var labelsTextColor: UIColor = .white {
        didSet {
            self.crosswordLabel.textColor = labelsTextColor
            self.questionsView.labelTextColor = labelsTextColor
        }
    }
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let viewCornerRadius: CGFloat = 20
        static let crosswordTitleLabelFontSize: CGFloat = 24
    }
    
    // MARK: - Private properties
    private var blocksMatrix: [[CrosswordBlock]] = [[]]
    private var blockIndexWordIndexDict: [Int : [Int]] = [:]
    private var selectedBlock: CrosswordBlock?
    private let rows: Int
    private let columns: Int
    private let words: [Word]
    private var stackViewHeightConstraint: NSLayoutConstraint?
    private var questionViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - UI properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.backgroundColor = .clear
        return stack
    }()
    
    private lazy var questionsView: QuestionsView = {
        let questions = words.map { $0.question }
        let view = QuestionsView(questions: questions)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var crosswordLabel: UILabel = {
        let label = UILabel()
        label.textColor = labelsTextColor
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.crosswordTitleLabelFontSize)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.text = "Crossword Game"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inits
    init(state: AppsViewState, rows: Int, columns: Int, words: [Word]) {
        self.rows = rows
        self.columns = columns
        self.words = words
        self.blocksMatrix = (0..<rows).map { _ in
            (0..<columns).map { _ in CrosswordBlock(type: .empty, id: 0) }
        }
        super.init(state: state)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    override func previewState() {
        stackView.isHidden = true
        questionsView.isHidden = true
    }
    
    override func halfScreenState() {
        stackView.isHidden = false
        questionsView.isHidden = true
    }
    
    override func fullScreenState() {
        stackView.isHidden = false
        questionsView.isHidden = false
    }
    
    override func layoutSubviews() {
        let avaliableHeight = self.frame.height
        let labelHeight = crosswordLabel.bounds.height
        let stackWidth: CGFloat = stackView.frame.width
        let blockWidth: CGFloat = (stackWidth - CGFloat(10 * (columns - 1))) / CGFloat(columns)
        if state == .halfScreen {
            let avaliableStackHeight = avaliableHeight - labelHeight - CGFloat(52)
            let stackHeight: CGFloat = blockWidth * CGFloat(rows) + CGFloat((rows - 1) * 10)
            let height = min(stackHeight, avaliableStackHeight)
            if stackViewHeightConstraint == nil {
                stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: height)
                stackViewHeightConstraint?.isActive = true
            } else {
                stackViewHeightConstraint?.constant = height
            }
        } else if state == .fullScreen {
            let stackHeight: CGFloat = blockWidth * CGFloat(rows) + CGFloat((rows - 1) * 10)
            let questionViewHeight: CGFloat = avaliableHeight - labelHeight - stackHeight - CGFloat(72)
            if stackViewHeightConstraint == nil {
                stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: stackHeight)
                stackViewHeightConstraint?.isActive = true
            } else {
                stackViewHeightConstraint?.constant = stackHeight
            }
            if questionViewHeightConstraint == nil && questionViewHeight > 0 {
                questionViewHeightConstraint = questionsView.heightAnchor.constraint(equalToConstant: questionViewHeight)
                questionViewHeightConstraint?.isActive = true
            } else {
                questionViewHeightConstraint?.constant = questionViewHeight
            }
        }
    }
    
    // MARK: - Private functions
    private func setupView() {
        backgroundColor = viewBackgroundColor
        layer.cornerRadius = UIConstants.viewCornerRadius
        
        [crosswordLabel, stackView, questionsView].forEach({contentStackView.addArrangedSubview($0)})
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.contentInset),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.contentInset),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.contentInset),
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.contentInset),
            
            questionsView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ])
        getCrosswordWords()
        createCrossword()
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        questionsView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func getCrosswordWords() {
        for i in 0...words.count - 1 {
            let word = words[i]
            let letters = Array(word.value)
            let x = (word.start - 1) / columns
            let y = (word.start - 1) - x * columns
            let block = CrosswordBlock(type: .start(i + 1), id: x * columns + y + 1)
            block.delegate = self
            blocksMatrix[x][y] = block
            addWordIndexToDict(index: x * columns + y + 1, wordIndex: i)
            block.translatesAutoresizingMaskIntoConstraints = false
            for letter in 1...letters.count - 1 {
                var block: CrosswordBlock
                if word.axis == .horizontal {
                    block = CrosswordBlock(type: .regular, id: x * columns + y + letter + 1)
                    blocksMatrix[x][y + letter] = block
                    addWordIndexToDict(index: x * columns + y + letter + 1, wordIndex: i)
                } else {
                    block = CrosswordBlock(type: .regular, id: (x + letter) * columns + y + 1)
                    blocksMatrix[x + letter][y] = block
                    addWordIndexToDict(index: (x + letter) * columns + y + 1, wordIndex: i)
                }
                block.delegate = self
                block.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    private func addWordIndexToDict(index: Int, wordIndex: Int) {
        if var array = blockIndexWordIndexDict[index] {
            array.append(wordIndex)
            blockIndexWordIndexDict[index] = array
        } else {
            blockIndexWordIndexDict[index] = [wordIndex]
        }
    }
    
    private func createCrossword() {
        for row in 0...rows - 1 {
            let hStack = UIStackView()
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.axis = .horizontal
            hStack.distribution = .fillEqually
            hStack.alignment = .fill
            hStack.spacing = 10
            for column in 0...columns - 1 {
                let block = blocksMatrix[row][column]
                hStack.addArrangedSubview(block)
            }
            stackView.addArrangedSubview(hStack)
        }
    }
}

// MARK: - Implementation CrosswordBlockDelegate
extension CrosswordView: CrosswordBlockDelegate {
    
    func didEnteredValue(block: CrosswordBlock) {
        let indexes = blockIndexWordIndexDict[block.id] ?? []
        for wordIndex in indexes {
            let word = words[wordIndex]
            let start = word.start
            let axis = word.axis
            var string = ""
            var blocks: [CrosswordBlock] = []
            let x = (start - 1) / columns
            let y = (start - 1) - x * columns
            for index in 0...word.value.count - 1 {
                let block = axis == .vertical ? blocksMatrix[x + index][y] : blocksMatrix[x][y + index]
                blocks.append(block)
                string += block.enteredLetter
            }
            if string.uppercased() == word.value.uppercased() {
                blocks.forEach({$0.isGuessed = true})
            }
        }
    }
    
    func didTapped(block: CrosswordBlock) {
        if !block.isGuessed {
            selectedBlock?.unselected()
            selectedBlock = block
            selectedBlock?.selected()
        }
    }
}
