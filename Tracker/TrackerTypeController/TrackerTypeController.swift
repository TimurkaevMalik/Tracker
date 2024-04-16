//
//  CreatingTracker.swift
//  Tracker
//
//  Created by Malik Timurkaev on 12.04.2024.
//

import Foundation
import UIKit

class TrackerTypeController: UIViewController {
    
    let habbit = UIButton()
    let irregularEvent = UIButton()
    let titleLabel = UILabel()
    
    var delegate: CreatingTrackerDelegate?
    
    func configureCreatingTrackerView(){
        view.backgroundColor = UIColor(named: "YPWhite")
        
        habbit.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
        irregularEvent.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        
        
        habbit.setTitle("Привычка", for: .normal)
        habbit.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        habbit.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habbit.layer.cornerRadius = 16
        habbit.layer.masksToBounds = true
        habbit.backgroundColor = UIColor(named: "YPBlack")
        
        
        irregularEvent.setTitle("Нерегулярные событие", for: .normal)
        irregularEvent.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        irregularEvent.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        irregularEvent.layer.cornerRadius = 16
        irregularEvent.layer.masksToBounds = true
        irregularEvent.backgroundColor = UIColor(named: "YPBlack")
        
        
        view.addSubviews([habbit, irregularEvent])
        habbit.translatesAutoresizingMaskIntoConstraints = false
        irregularEvent.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            habbit.widthAnchor.constraint(equalToConstant: 335),
            habbit.heightAnchor.constraint(equalToConstant: 60),
            habbit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habbit.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -357),
            
            irregularEvent.widthAnchor.constraint(equalToConstant: 335),
            irregularEvent.heightAnchor.constraint(equalToConstant: 60),
            irregularEvent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEvent.topAnchor.constraint(equalTo: habbit.bottomAnchor, constant: 16),
        ])
    }
    
    func configureTitleLable(){
        
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 149),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -712)
        ])
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.CreatingTrackerViewDidDismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleLable()
        configureCreatingTrackerView()
        
    }
    
    
    @objc func habbitButtonTapped(){
        
        print("Habbit Button Tapped")
        
        let viewController = MakeTrackerController()
        present(viewController, animated: true)
    }
    
    @objc func irregularEventButtonTapped(){
        
        print("Irregular Event Button Tapped")
    }
}
