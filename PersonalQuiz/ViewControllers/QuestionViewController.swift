//
//  QuestionViewController.swift
//  PersonalQuiz
//
//  Created by Alexey Efimov on 03.04.2023.
//

import UIKit

final class QuestionViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var questionProgressView: UIProgressView!
    
    @IBOutlet private var singleStackView: UIStackView!
    @IBOutlet private var singleButtons: [UIButton]!
    
    @IBOutlet private var multipleStackView: UIStackView!
    @IBOutlet private var multipleLabels: [UILabel]!
    @IBOutlet private var multipleSwitches: [UISwitch]!
    
    @IBOutlet private var rangedStackView: UIStackView!
    @IBOutlet private var rangedLabels: [UILabel]!
    @IBOutlet private var rangedSlider: UISlider!
    
    // MARK: - Private properties
    private var questionIndex = 0
    private let questions = Question.getQuestions()
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        let answerCount = Float(currentAnswers.count - 1)
        rangedSlider.maximumValue = answerCount
        rangedSlider.value = answerCount / 2
    }

    // MARK: - IB Actions
    @IBAction private func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction private func multipleButtonAnswerPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction private func rangerAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
}

// MARK: - Private Methods
private extension QuestionViewController {
    func updateUI() {
        // Hide everything
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for question label
        questionLabel.text = currentQuestion.title
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for progress view
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Show stacks corresponding to question type
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    /// Show stack view with single answers
    ///
    /// Display a stack view of single answers category
    ///
    /// - Parameter type: Specifies the category of responses
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .multiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}