//
//  RedBoardController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 19.05.2024.
//

import UIKit

class RedBoardController: UIViewController {
    
    private let redBoardImage = UIImageView()
    private let onboardingText = UILabel()
    
    func configureBoardImage() {
        
        redBoardImage.image = .redBoardScreen
        
        redBoardImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redBoardImage)
        
        NSLayoutConstraint.activate([
            redBoardImage.topAnchor.constraint(equalTo: view.topAnchor),
            redBoardImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redBoardImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            redBoardImage.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func configureOnboardingText() {
        onboardingText.text = "Даже если это\nне литры воды и йога"
        onboardingText.font = UIFont.boldSystemFont(ofSize: 32)
        onboardingText.tintColor = .ypBlack
        onboardingText.numberOfLines = 2
        onboardingText.textAlignment = .center

        onboardingText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboardingText)
        
        NSLayoutConstraint.activate([
            onboardingText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 388),
            onboardingText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            onboardingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            onboardingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBoardImage()
        configureOnboardingText()
    }
}
