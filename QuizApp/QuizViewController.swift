//
//  QuizViewController.swift
//  QuizApp
//
//  Created by emre on 21.06.2024.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var questions: [Question] = []
    var currentQuestionIndex: Int = 0
    var correctAnswersCount: Int = 0
    var answeredQuestions: [Int: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
        configurePageControl()
    }
    
    func configurePageControl() {
        pageControl.numberOfPages = questions.count
        pageControl.currentPage = currentQuestionIndex
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
    }
    
    func loadQuestion() {
        guard currentQuestionIndex < questions.count else {
            return
        }
        
        let question = questions[currentQuestionIndex]
        questionLabel.text = "Soru \(currentQuestionIndex + 1)) \(question.text)"
        let prefixes = ["A)", "B)", "C)", "D)"]
        
        for (index, button) in answerButtons.enumerated() {
            let answerText = prefixes[index] + " " + question.answers[index]
            button.setTitle(answerText, for: .normal)
            button.isEnabled = true
            button.backgroundColor = .clear
        }
        
        if let selectedAnswerIndex = answeredQuestions[currentQuestionIndex] {
            let button = answerButtons[selectedAnswerIndex]
            button.backgroundColor = .lightGray
        }
        
        updateUI()
    }
    
    func updateUI() {
        pageControl.currentPage = currentQuestionIndex
    }
    
    @IBAction func answerTapped(_ sender: UIButton) {
        let selectedAnswerIndex = answerButtons.firstIndex(of: sender)!
        let correctAnswerIndex = questions[currentQuestionIndex].correctAnswer
        
        if let previousAnswerIndex = answeredQuestions[currentQuestionIndex],
           previousAnswerIndex == correctAnswerIndex && selectedAnswerIndex != correctAnswerIndex {
            correctAnswersCount -= 1
        }
        
        if selectedAnswerIndex == correctAnswerIndex && answeredQuestions[currentQuestionIndex] != correctAnswerIndex {
            correctAnswersCount += 1
        }
        
        answerButtons.forEach { button in
            button.backgroundColor = .clear
        }
        
        answeredQuestions[currentQuestionIndex] = selectedAnswerIndex
        
        sender.backgroundColor = .lightGray
    }
    
    func showQuizSummary() {
        questionLabel.text = "Quiz tamamlandı"
        answerButtons.forEach { $0.isHidden = true }
        completeButton.isHidden = true
        pageControl.isHidden = true
        
        let correctAnswers = correctAnswersCount
        
        let score = "\(correctAnswers) / \(questions.count)"
        let scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        scoreLabel.center = CGPoint(x: view.center.x, y: view.center.y + 50)
        scoreLabel.textAlignment = .center
        scoreLabel.text = "Skor: \(score)"
        scoreLabel.numberOfLines = 0
        view.addSubview(scoreLabel)
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        showQuizSummary()
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        currentQuestionIndex = sender.currentPage
        loadQuestion()
    }
}
