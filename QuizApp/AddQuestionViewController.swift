//
//  AddQuestionViewController.swift
//  QuizApp
//
//  Created by emre on 21.06.2024.
//

import UIKit

class AddQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet var answerTextFields: [UITextField]!
    @IBOutlet weak var correctAnswerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var solveQuestionsButton: UIButton!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var resetQuestions: UIButton!
    
    var questions: [Question] = [] {
        didSet {
            solveQuestionsButton.isEnabled = !questions.isEmpty
            updatePageControl()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        solveQuestionsButton.isEnabled = false
        updatePageControl()
        loadQuestion(at: 0)
    }
    
    @IBAction func addQuestionTapped(_ sender: UIButton) {
        guard let questionText = questionTextField.text, !questionText.isEmpty,
              let answer1 = answerTextFields[0].text, !answer1.isEmpty,
              let answer2 = answerTextFields[1].text, !answer2.isEmpty,
              let answer3 = answerTextFields[2].text, !answer3.isEmpty,
              let answer4 = answerTextFields[3].text, !answer4.isEmpty else {
            let alertController = UIAlertController(title: "Hata", message: "Lütfen tüm alanları doldurun.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        
            return
        }
        
        let correctAnswer = correctAnswerSegmentedControl.selectedSegmentIndex
        let newQuestion = Question(text: questionText, answers: [answer1, answer2, answer3, answer4], correctAnswer: correctAnswer)
        
        if pageControl.currentPage < questions.count {
            questions[pageControl.currentPage] = newQuestion
            addQuestionButton.setTitle("Ekle", for: .normal)
        } else {
            questions.append(newQuestion)
        }
        
        questionTextField.text = ""
        answerTextFields.forEach { $0.text = "" }
        correctAnswerSegmentedControl.selectedSegmentIndex = 0
        
        pageControl.currentPage = questions.count
        loadQuestion(at: pageControl.currentPage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuiz", !questions.isEmpty {
            let quizVC = segue.destination as! QuizViewController
            quizVC.questions = questions
        }
    }
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        loadQuestion(at: sender.currentPage)
    }
    
    private func updateQuestionCountLabel(for index: Int) {
        questionNumber.text = "\(index + 1)"
    }
    
    private func updatePageControl() {
        pageControl.numberOfPages = questions.count + 1
    }
    
    private func loadQuestion(at index: Int) {
        updateQuestionCountLabel(for: index)
        
        if index < questions.count {
            let question = questions[index]
            questionTextField.text = question.text
            for (i, answerTextField) in answerTextFields.enumerated() {
                answerTextField.text = question.answers[i]
            }
            correctAnswerSegmentedControl.selectedSegmentIndex = question.correctAnswer
            addQuestionButton.setTitle("Güncelle", for: .normal)
        } else {
            questionTextField.text = ""
            answerTextFields.forEach { $0.text = "" }
            correctAnswerSegmentedControl.selectedSegmentIndex = 0
            addQuestionButton.setTitle("Ekle", for: .normal)
        }
    }
    
    @IBAction func resetQuestionsTapped(_ sender: UIButton) {
        // Soruları temizle
        questions.removeAll()
        updatePageControl()
        loadQuestion(at: 0)
    }
}
