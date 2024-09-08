//
//  QuestionsView.swift
//  MiniApps
//
//  Created by Evelina on 07.09.2024.
//

import Foundation
import UIKit

class QuestionsView: UIView {
    
    var labelTextColor: UIColor = .white {
        didSet {
            questionsTableView.reloadData()
        }
    }
    
    // MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
    }
    
    // MARK: - UI properties
    private lazy var questionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: String(describing: QuestionTableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Private properties
    private let questions: [String]
    
    // MARK: - Inits
    init(questions: [String]) {
        self.questions = questions
        super.init(frame: CGRect())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(questionsTableView)
        NSLayoutConstraint.activate([
            questionsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            questionsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            questionsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            questionsTableView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}

// MARK: - Implementation UITableViewDelegate, UITableViewDataSource
extension QuestionsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuestionTableViewCell.self), for: indexPath) as? QuestionTableViewCell else { return QuestionTableViewCell()}
        cell.labelTextColor = labelTextColor
        cell.setQuestionForCell(question: questions[indexPath.row], index: indexPath.row)
        return cell
    }
}
