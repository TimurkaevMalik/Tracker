//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Malik Timurkaev on 04.04.2024.
//

import UIKit


final class StatisticViewController: UIViewController {
    
    private lazy var titleLabel = UILabel()
    private lazy var centralPlugLabel = UILabel()
    private lazy var centralPlugImage = UIImageView()
    
    func configureLabelsViews(){
        view.backgroundColor = UIColor(named: "YPWhite")
        
        titleLabel.text = "Статистика"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        
        centralPlugLabel.text = "Анализировать пока нечего"
        centralPlugLabel.font = UIFont.systemFont(ofSize: 12)
        centralPlugLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        centralPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([titleLabel, centralPlugLabel])
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            centralPlugLabel.widthAnchor.constraint(equalToConstant: 180),
            centralPlugLabel.heightAnchor.constraint(equalToConstant: 18),
            centralPlugLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 419),
            centralPlugLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func configureCentralPlug(){
        centralPlugImage.image = UIImage(named: "StatisticPlug")
        
        centralPlugImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centralPlugImage)
        
        NSLayoutConstraint.activate([
            centralPlugImage.widthAnchor.constraint(equalToConstant: 80),
            centralPlugImage.heightAnchor.constraint(equalToConstant: 80),
            centralPlugImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            centralPlugImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 331)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabelsViews()
        configureCentralPlug()
    }
}
