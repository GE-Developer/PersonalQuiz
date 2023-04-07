//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Alexey Efimov on 06.04.2023.
//

import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet private var yourResultLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var answersChosen: [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        yourResultLabel.text = "Вы - \(setResult().rawValue)"
        descriptionLabel.text = setResult().definition
    }
    
    @IBAction private func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    private func setResult() -> Animal {
        
        var animals: [Animal: Int] = [:]
        
        for answer in answersChosen {
            animals[answer.animal, default: 0] += 1
        }
        
        let sortedAnimals = animals.sorted { $0.value > $1.value }
        let animal = sortedAnimals.first?.key ?? .cat
        
        return animal
    }
}
